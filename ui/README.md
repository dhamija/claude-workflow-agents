# Workflow Control Center UI

> Visual control interface for Claude Workflow Agents

## Overview

The Workflow Control Center provides a visual interface for managing and monitoring the Claude Workflow system. It allows users to:

- View and edit workflow artifacts (Intent, UX, Architecture, Plan)
- Track implementation progress in real-time
- Manage gaps and enhancements
- Monitor Claude Code integration
- Execute workflow commands visually

## Architecture

### Technology Stack

- **Frontend Framework:** React 18 with TypeScript
- **State Management:** Zustand with devtools
- **UI Components:** Radix UI + Tailwind CSS
- **Build Tool:** Vite
- **Testing:** Vitest + Testing Library + Playwright
- **Real-time Updates:** Socket.io

### Component Structure

```
src/
├── components/          # React components
│   ├── WorkflowGrid    # Main grid layout
│   ├── ArtifactCard    # Individual artifact display
│   ├── Implementation  # L2 phase tracking
│   └── ui/            # Reusable UI components
├── services/           # API and WebSocket services
├── stores/            # Zustand state management
├── types/             # TypeScript definitions
└── utils/             # Helper functions
```

## Getting Started

### Prerequisites

- Node.js 18+
- Claude Workflow Agents installed
- Active project with workflow initialized

### Installation

```bash
# From repository root
cd ui
npm install
```

### Development

```bash
# Start development server
npm run dev

# The UI will be available at http://localhost:3000
```

### Production Build

```bash
# Build for production
npm run build

# Preview production build
npm run preview
```

## Integration with Claude Code

### Connection Modes

The UI operates in two modes:

1. **Integrated Mode** - Full bidirectional communication with Claude Code
2. **Standalone Mode** - Read-only view when Claude is not connected

### Task Queue System

The UI communicates with Claude Code through a file-based task queue:

```
.claude/
├── tasks/
│   ├── pending/       # New tasks for Claude
│   ├── progress/      # Progress updates
│   └── completed/     # Finished tasks
```

### Connecting Claude Code

In your Claude Code session:

```bash
# Start the UI service
workflow-ui start

# Or connect to existing UI
workflow-ui connect http://localhost:3000
```

## Features

### Artifact Management

Each L1 artifact (Intent, UX, Architecture, Plan) can be:
- **Viewed** - Display current content with syntax highlighting
- **Edited** - In-place editing with Monaco editor
- **Regenerated** - Evolve to new version or replace completely
- **Compared** - Side-by-side diff view of versions

### Enhancement Workflow

1. Click "Add Enhancement"
2. Describe the enhancement
3. System analyzes impact on artifacts
4. Review affected areas
5. Approve to trigger regeneration cascade

### Gap Tracking

- Unified view of all gap types (Reality, User, Analysis, Infrastructure)
- Sort and filter by severity
- One-click fix initiation
- Progress tracking

### Real-time Updates

- WebSocket connection for live updates
- Progress bars for running tasks
- Activity log with timestamps
- Artifact change notifications

## API Reference

### REST Endpoints

```typescript
GET  /api/workflow/state        # Get workflow state
GET  /api/workflow/artifacts    # List all artifacts
POST /api/workflow/enhance      # Create enhancement
POST /api/workflow/artifacts/:type/regenerate
PUT  /api/workflow/artifacts/:type
GET  /api/workflow/gaps
POST /api/workflow/gaps/:id/fix
```

### WebSocket Events

```typescript
// Client → Server
'command'        # Execute workflow command
'request:update' # Request state refresh

// Server → Client
'task:progress'    # Task progress update
'task:complete'    # Task completion
'artifact:updated' # Artifact changed
'activity:log'     # New log entry
```

## Testing

### Unit Tests

```bash
# Run unit tests
npm test

# With coverage
npm run test:coverage

# Watch mode
npm run test:watch
```

### E2E Tests

```bash
# Run Playwright tests
npm run test:e2e

# Interactive mode
npm run test:e2e -- --ui
```

### Component Testing

```bash
# Storybook for component development
npm run storybook
```

## Configuration

### Environment Variables

```bash
# .env.local
VITE_API_URL=http://localhost:4000
VITE_WEBSOCKET_URL=ws://localhost:4000
VITE_CLAUDE_CHECK_INTERVAL=30000
```

### Customization

The UI uses Tailwind CSS for styling. Customize the theme in `tailwind.config.js`:

```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        workflow: {
          intent: '#3B82F6',    // Blue
          ux: '#10B981',        // Green
          architecture: '#F59E0B', // Yellow
          plan: '#8B5CF6',      // Purple
        }
      }
    }
  }
}
```

## Deployment

### Docker

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

### Static Hosting

The built UI can be deployed to any static hosting service:

```bash
# Build
npm run build

# Deploy dist/ folder to:
# - Vercel
# - Netlify
# - GitHub Pages
# - AWS S3 + CloudFront
```

## Contributing

### Development Guidelines

1. **Component Structure**
   - Use functional components with hooks
   - Keep components focused and single-purpose
   - Extract reusable logic to custom hooks

2. **State Management**
   - Use Zustand store for global state
   - Keep component state local when possible
   - Use React Query for server state

3. **Type Safety**
   - Define types for all props and state
   - Use strict TypeScript settings
   - Avoid `any` types

4. **Testing**
   - Write tests for all new components
   - Maintain >80% coverage
   - Test user interactions, not implementation

### Code Style

```bash
# Format code
npm run format

# Lint
npm run lint

# Type check
npm run typecheck
```

## Troubleshooting

### Common Issues

**UI not connecting to Claude:**
- Ensure workflow-ui service is running
- Check `.claude/tasks/` directory permissions
- Verify WebSocket connection in browser console

**Artifacts not updating:**
- Check file watchers are active
- Verify git status detection
- Ensure proper file permissions

**Performance issues:**
- Reduce activity log limit
- Enable React.memo for large lists
- Use virtualization for long content

## License

MIT - See LICENSE file in repository root

## Support

- GitHub Issues: [claude-workflow-agents/issues](https://github.com/your-org/claude-workflow-agents/issues)
- Documentation: [docs/ui/](../docs/ui/)
- Discord: [Join our community](https://discord.gg/workflow)