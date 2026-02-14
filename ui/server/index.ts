/**
 * Backend service for Workflow UI
 * Bridges between the UI and Claude Code via file system
 */

import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import fs from 'fs/promises';
import path from 'path';
import chokidar from 'chokidar';
import yaml from 'js-yaml';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: ['http://localhost:3000', 'http://localhost:5173'],
    methods: ['GET', 'POST'],
  },
});

// Middleware
app.use(cors());
app.use(express.json());

// Configuration
const PROJECT_ROOT = process.env.PROJECT_ROOT || process.cwd();
const CLAUDE_DIR = path.join(PROJECT_ROOT, '.claude');
const TASKS_DIR = path.join(CLAUDE_DIR, 'tasks');
const DOCS_DIR = path.join(PROJECT_ROOT, 'docs');
const CLAUDE_MD_PATH = path.join(PROJECT_ROOT, 'CLAUDE.md');

// Ensure directories exist
async function ensureDirectories() {
  await fs.mkdir(path.join(TASKS_DIR, 'pending'), { recursive: true });
  await fs.mkdir(path.join(TASKS_DIR, 'progress'), { recursive: true });
  await fs.mkdir(path.join(TASKS_DIR, 'completed'), { recursive: true });
}

// Parse CLAUDE.md to get workflow state
async function parseWorkflowState() {
  try {
    const content = await fs.readFile(CLAUDE_MD_PATH, 'utf-8');
    const yamlMatch = content.match(/```yaml\nworkflow:(.*?)```/s);

    if (yamlMatch) {
      const yamlContent = 'workflow:' + yamlMatch[1];
      const parsed = yaml.load(yamlContent) as any;
      return parsed.workflow;
    }
  } catch (error) {
    console.error('Error parsing CLAUDE.md:', error);
  }

  return null;
}

// Get artifact content
async function getArtifact(type: string) {
  const paths: Record<string, string> = {
    intent: path.join(DOCS_DIR, 'intent', 'product-intent.md'),
    ux: path.join(DOCS_DIR, 'ux', 'user-journeys.md'),
    architecture: path.join(DOCS_DIR, 'architecture', 'system-design.md'),
    plan: path.join(DOCS_DIR, 'plans', 'implementation-order.md'),
  };

  const artifactPath = paths[type];
  if (!artifactPath) return null;

  try {
    const content = await fs.readFile(artifactPath, 'utf-8');
    const stats = await fs.stat(artifactPath);

    // Parse items from content (simplified)
    const items = [];
    if (type === 'intent') {
      const promises = content.match(/## P\d+:.*$/gm) || [];
      items.push(...promises.map(p => ({
        id: p.match(/P\d+/)?.[0] || '',
        name: p.replace(/## P\d+:\s*/, ''),
        status: 'complete' as const,
      })));
    }

    return {
      type,
      version: 'v2.0', // Parse from content if available
      status: 'current' as const,
      lastModified: stats.mtime,
      path: artifactPath,
      content,
      items,
      canRegenerate: true,
    };
  } catch (error) {
    return null;
  }
}

// Get gaps from docs/gaps directory
async function getGaps() {
  const gapsDir = path.join(DOCS_DIR, 'gaps', 'gaps');
  const gaps = [];

  try {
    const files = await fs.readdir(gapsDir);
    for (const file of files) {
      if (file.endsWith('.yaml')) {
        const content = await fs.readFile(path.join(gapsDir, file), 'utf-8');
        const gap = yaml.load(content) as any;
        gaps.push(gap);
      }
    }
  } catch (error) {
    console.error('Error reading gaps:', error);
  }

  return gaps;
}

// API Routes
app.get('/api/workflow/state', async (req, res) => {
  const state = await parseWorkflowState();
  res.json(state || {
    version: '3.8',
    type: 'greenfield',
    phase: 'L1',
    status: 'not_started',
    mode: 'auto',
    lastUpdated: new Date(),
  });
});

app.get('/api/workflow/artifacts', async (req, res) => {
  const artifacts = await Promise.all([
    getArtifact('intent'),
    getArtifact('ux'),
    getArtifact('architecture'),
    getArtifact('plan'),
  ]);

  res.json(artifacts.filter(Boolean));
});

app.get('/api/workflow/artifacts/:type', async (req, res) => {
  const artifact = await getArtifact(req.params.type);
  if (artifact) {
    res.json(artifact);
  } else {
    res.status(404).json({ error: 'Artifact not found' });
  }
});

app.get('/api/workflow/gaps', async (req, res) => {
  const gaps = await getGaps();
  res.json(gaps);
});

app.get('/api/workflow/tasks', async (req, res) => {
  const tasks = [];

  // Read pending tasks
  try {
    const pendingDir = path.join(TASKS_DIR, 'pending');
    const files = await fs.readdir(pendingDir);
    for (const file of files) {
      if (file.endsWith('.json')) {
        const content = await fs.readFile(path.join(pendingDir, file), 'utf-8');
        const task = JSON.parse(content);
        tasks.push({ ...task, status: 'pending' });
      }
    }
  } catch (error) {
    // Directory might not exist
  }

  // Read in-progress tasks
  try {
    const progressDir = path.join(TASKS_DIR, 'progress');
    const files = await fs.readdir(progressDir);
    for (const file of files) {
      if (file.endsWith('.json')) {
        const content = await fs.readFile(path.join(progressDir, file), 'utf-8');
        const task = JSON.parse(content);
        tasks.push({ ...task, status: 'in_progress' });
      }
    }
  } catch (error) {
    // Directory might not exist
  }

  res.json(tasks);
});

app.post('/api/workflow/enhance', async (req, res) => {
  const { description } = req.body;

  const enhancement = {
    id: `enh-${Date.now()}`,
    description,
    affectedArtifacts: ['intent', 'ux', 'architecture'],
    estimatedTime: 300,
    status: 'pending',
    createdAt: new Date(),
  };

  // Create task for Claude
  const task = {
    id: `task-${Date.now()}`,
    type: 'enhancement',
    enhancement,
    command: `/workflow-plan "${description}"`,
    createdAt: new Date(),
  };

  await fs.writeFile(
    path.join(TASKS_DIR, 'pending', `${task.id}.json`),
    JSON.stringify(task, null, 2)
  );

  res.json(enhancement);

  // Notify via WebSocket
  io.emit('activity:log', {
    id: Date.now().toString(),
    timestamp: new Date(),
    type: 'info',
    message: `Enhancement created: ${description}`,
  });
});

app.post('/api/workflow/artifacts/:type/regenerate', async (req, res) => {
  const { type } = req.params;
  const { mode = 'evolve' } = req.body;

  const task = {
    id: `task-${Date.now()}`,
    type: 'regenerate',
    artifact: type,
    mode,
    command: `Task: ${type}-guardian with mode=${mode}`,
    description: `Regenerating ${type} artifact`,
    createdAt: new Date(),
  };

  await fs.writeFile(
    path.join(TASKS_DIR, 'pending', `${task.id}.json`),
    JSON.stringify(task, null, 2)
  );

  res.json(task);

  // Update artifact status
  io.emit('artifact:updated', {
    type,
    status: 'regenerating',
  });
});

app.get('/api/workflow/activity', async (req, res) => {
  // In production, this would read from a persistent log
  res.json([
    {
      id: '1',
      timestamp: new Date(),
      type: 'info',
      message: 'Workflow UI started',
    },
  ]);
});

app.get('/api/claude/status', async (req, res) => {
  // Check if Claude is connected by looking for a marker file
  try {
    await fs.access(path.join(CLAUDE_DIR, 'connected'));
    res.json({ connected: true, mode: 'integrated' });
  } catch {
    res.json({ connected: false, mode: 'standalone' });
  }
});

// File Watchers
function setupWatchers() {
  // Watch task directories
  const taskWatcher = chokidar.watch([
    path.join(TASKS_DIR, 'progress', '*.json'),
    path.join(TASKS_DIR, 'completed', '*.json'),
  ], {
    ignoreInitial: true,
  });

  taskWatcher.on('add', async (filePath) => {
    const content = await fs.readFile(filePath, 'utf-8');
    const task = JSON.parse(content);

    if (filePath.includes('progress')) {
      io.emit('task:progress', {
        taskId: task.id,
        progress: task.progress || 0.5,
      });
    } else if (filePath.includes('completed')) {
      io.emit('task:complete', task);
    }
  });

  taskWatcher.on('change', async (filePath) => {
    const content = await fs.readFile(filePath, 'utf-8');
    const task = JSON.parse(content);

    if (filePath.includes('progress')) {
      io.emit('task:progress', {
        taskId: task.id,
        progress: task.progress || 0.5,
      });
    }
  });

  // Watch artifact files
  const artifactWatcher = chokidar.watch([
    path.join(DOCS_DIR, '**/*.md'),
  ], {
    ignoreInitial: true,
  });

  artifactWatcher.on('change', async (filePath) => {
    // Determine artifact type from path
    let type = null;
    if (filePath.includes('intent')) type = 'intent';
    else if (filePath.includes('ux')) type = 'ux';
    else if (filePath.includes('architecture')) type = 'architecture';
    else if (filePath.includes('plans')) type = 'plan';

    if (type) {
      const artifact = await getArtifact(type);
      if (artifact) {
        io.emit('artifact:updated', artifact);
      }
    }
  });

  // Watch CLAUDE.md for state changes
  const stateWatcher = chokidar.watch(CLAUDE_MD_PATH, {
    ignoreInitial: true,
  });

  stateWatcher.on('change', async () => {
    const state = await parseWorkflowState();
    io.emit('state:updated', state);
  });
}

// WebSocket Connection
io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);

  socket.on('command', async (data) => {
    const { command, args } = data;

    // Create task for Claude
    const task = {
      id: `task-${Date.now()}`,
      type: 'command',
      command,
      args,
      createdAt: new Date(),
    };

    await fs.writeFile(
      path.join(TASKS_DIR, 'pending', `${task.id}.json`),
      JSON.stringify(task, null, 2)
    );

    socket.emit('command:queued', task);
  });

  socket.on('request:update', async (data) => {
    const { type } = data;

    switch (type) {
      case 'state':
        const state = await parseWorkflowState();
        socket.emit('state:updated', state);
        break;
      case 'artifacts':
        const artifacts = await Promise.all([
          getArtifact('intent'),
          getArtifact('ux'),
          getArtifact('architecture'),
          getArtifact('plan'),
        ]);
        socket.emit('artifacts:updated', artifacts.filter(Boolean));
        break;
      case 'gaps':
        const gaps = await getGaps();
        socket.emit('gaps:updated', gaps);
        break;
      case 'tasks':
        // Send current tasks
        break;
    }
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

// Start Server
const PORT = process.env.PORT || 4000;

async function start() {
  await ensureDirectories();
  setupWatchers();

  server.listen(PORT, () => {
    console.log(`
╔════════════════════════════════════════════════════════════════╗
║     Workflow UI Server                                        ║
╚════════════════════════════════════════════════════════════════╝

  API:       http://localhost:${PORT}
  WebSocket: ws://localhost:${PORT}

  Project:   ${PROJECT_ROOT}

  Status:    Ready for connections

  In Claude Code, run:
    workflow-ui connect http://localhost:${PORT}
    `);
  });
}

start().catch(console.error);