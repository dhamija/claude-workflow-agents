/**
 * Zustand store for workflow state management
 */

import { create } from 'zustand';
import { devtools, subscribeWithSelector } from 'zustand/middleware';
import type {
  WorkflowState,
  ArtifactState,
  ImplementationState,
  Gap,
  Task,
  ActivityLogEntry,
  Enhancement,
  ArtifactType,
} from '@/types/workflow';
import { workflowApi } from '@/services/api';
import { websocket } from '@/services/websocket';

interface WorkflowStore {
  // State
  workflowState: WorkflowState | null;
  artifacts: ArtifactState[];
  implementation: ImplementationState[];
  gaps: Gap[];
  tasks: Task[];
  activityLog: ActivityLogEntry[];
  currentEnhancement: Enhancement | null;

  // UI State
  isLoading: boolean;
  error: string | null;
  claudeConnected: boolean;
  mode: 'integrated' | 'standalone';
  selectedArtifact: ArtifactType | null;

  // Actions
  initialize: () => Promise<void>;
  fetchState: () => Promise<void>;
  fetchArtifacts: () => Promise<void>;
  fetchGaps: () => Promise<void>;
  fetchTasks: () => Promise<void>;
  fetchActivityLog: () => Promise<void>;

  // Artifact Operations
  regenerateArtifact: (type: ArtifactType, mode?: 'evolve' | 'replace') => Promise<void>;
  editArtifact: (type: ArtifactType, content: string) => Promise<void>;
  selectArtifact: (type: ArtifactType | null) => void;

  // Enhancement Operations
  createEnhancement: (description: string) => Promise<void>;
  approveEnhancement: (id: string) => Promise<void>;

  // Gap Operations
  fixGap: (id: string) => Promise<void>;
  verifyGap: (id: string) => Promise<void>;

  // Task Operations
  cancelTask: (id: string) => Promise<void>;
  updateTaskProgress: (taskId: string, progress: number) => void;
  completeTask: (task: Task) => void;

  // Activity Log
  addLogEntry: (entry: ActivityLogEntry) => void;
  clearActivityLog: () => void;

  // Claude Integration
  checkClaudeConnection: () => Promise<void>;
  sendToClaud: (command: string) => Promise<void>;

  // WebSocket Updates
  handleArtifactUpdate: (artifact: ArtifactState) => void;
  handleTaskProgress: (data: { taskId: string; progress: number }) => void;
  handleTaskComplete: (task: Task) => void;
  handleTaskError: (data: { taskId: string; error: string }) => void;
}

export const useWorkflowStore = create<WorkflowStore>()(
  devtools(
    subscribeWithSelector((set, get) => ({
      // Initial State
      workflowState: null,
      artifacts: [],
      implementation: [],
      gaps: [],
      tasks: [],
      activityLog: [],
      currentEnhancement: null,
      isLoading: false,
      error: null,
      claudeConnected: false,
      mode: 'standalone',
      selectedArtifact: null,

      // Initialize
      initialize: async () => {
        set({ isLoading: true, error: null });
        try {
          await Promise.all([
            get().fetchState(),
            get().fetchArtifacts(),
            get().fetchGaps(),
            get().fetchTasks(),
            get().fetchActivityLog(),
            get().checkClaudeConnection(),
          ]);

          // Set up WebSocket listeners
          websocket.connect();
          websocket.on('artifact:updated', get().handleArtifactUpdate);
          websocket.on('task:progress', get().handleTaskProgress);
          websocket.on('task:complete', get().handleTaskComplete);
          websocket.on('task:error', get().handleTaskError);
          websocket.on('activity:log', get().addLogEntry);
          websocket.on('claude:connected', () => set({ claudeConnected: true }));
          websocket.on('claude:disconnected', () => set({ claudeConnected: false }));
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      // Fetch Operations
      fetchState: async () => {
        const state = await workflowApi.getState();
        set({ workflowState: state });
      },

      fetchArtifacts: async () => {
        const artifacts = await workflowApi.getArtifacts();
        set({ artifacts });
      },

      fetchGaps: async () => {
        const gaps = await workflowApi.getGaps();
        set({ gaps });
      },

      fetchTasks: async () => {
        const tasks = await workflowApi.getTasks();
        set({ tasks });
      },

      fetchActivityLog: async () => {
        const log = await workflowApi.getActivityLog();
        set({ activityLog: log });
      },

      // Artifact Operations
      regenerateArtifact: async (type, mode = 'evolve') => {
        set({ isLoading: true, error: null });
        try {
          const task = await workflowApi.regenerateArtifact(type, mode);
          set((state) => ({
            tasks: [...state.tasks, task],
            artifacts: state.artifacts.map((a) =>
              a.type === type ? { ...a, status: 'regenerating' } : a
            ),
          }));
          get().addLogEntry({
            id: Date.now().toString(),
            timestamp: new Date(),
            type: 'info',
            message: `Started regenerating ${type} artifact`,
            artifactType: type,
            taskId: task.id,
          });
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      editArtifact: async (type, content) => {
        set({ isLoading: true, error: null });
        try {
          const artifact = await workflowApi.editArtifact(type, content);
          set((state) => ({
            artifacts: state.artifacts.map((a) =>
              a.type === type ? artifact : a
            ),
          }));
          get().addLogEntry({
            id: Date.now().toString(),
            timestamp: new Date(),
            type: 'success',
            message: `Updated ${type} artifact`,
            artifactType: type,
          });
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      selectArtifact: (type) => {
        set({ selectedArtifact: type });
      },

      // Enhancement Operations
      createEnhancement: async (description) => {
        set({ isLoading: true, error: null });
        try {
          const enhancement = await workflowApi.createEnhancement(description);
          set({ currentEnhancement: enhancement });
          get().addLogEntry({
            id: Date.now().toString(),
            timestamp: new Date(),
            type: 'info',
            message: `Enhancement created: ${description}`,
          });
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      approveEnhancement: async (id) => {
        set({ isLoading: true, error: null });
        try {
          const task = await workflowApi.approveEnhancement(id);
          set((state) => ({
            tasks: [...state.tasks, task],
            currentEnhancement: null,
          }));
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      // Gap Operations
      fixGap: async (id) => {
        set({ isLoading: true, error: null });
        try {
          const task = await workflowApi.fixGap(id);
          set((state) => ({
            tasks: [...state.tasks, task],
            gaps: state.gaps.map((g) =>
              g.id === id ? { ...g, status: 'in_progress' } : g
            ),
          }));
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      verifyGap: async (id) => {
        set({ isLoading: true, error: null });
        try {
          const task = await workflowApi.verifyGap(id);
          set((state) => ({
            tasks: [...state.tasks, task],
          }));
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      // Task Operations
      cancelTask: async (id) => {
        await workflowApi.cancelTask(id);
        set((state) => ({
          tasks: state.tasks.filter((t) => t.id !== id),
        }));
      },

      updateTaskProgress: (taskId, progress) => {
        set((state) => ({
          tasks: state.tasks.map((t) =>
            t.id === taskId ? { ...t, progress } : t
          ),
        }));
      },

      completeTask: (task) => {
        set((state) => ({
          tasks: state.tasks.map((t) =>
            t.id === task.id ? task : t
          ),
        }));
      },

      // Activity Log
      addLogEntry: (entry) => {
        set((state) => ({
          activityLog: [entry, ...state.activityLog].slice(0, 100),
        }));
      },

      clearActivityLog: () => {
        set({ activityLog: [] });
      },

      // Claude Integration
      checkClaudeConnection: async () => {
        const { connected, mode } = await workflowApi.checkClaudeConnection();
        set({ claudeConnected: connected, mode });
      },

      sendToClaud: async (command) => {
        set({ isLoading: true, error: null });
        try {
          const task = await workflowApi.sendToClaud(command);
          set((state) => ({
            tasks: [...state.tasks, task],
          }));
        } catch (error) {
          set({ error: (error as Error).message });
        } finally {
          set({ isLoading: false });
        }
      },

      // WebSocket Handlers
      handleArtifactUpdate: (artifact) => {
        set((state) => ({
          artifacts: state.artifacts.map((a) =>
            a.type === artifact.type ? artifact : a
          ),
        }));
      },

      handleTaskProgress: (data) => {
        get().updateTaskProgress(data.taskId, data.progress);
      },

      handleTaskComplete: (task) => {
        get().completeTask(task);
        get().addLogEntry({
          id: Date.now().toString(),
          timestamp: new Date(),
          type: 'success',
          message: `Task completed: ${task.description}`,
          taskId: task.id,
        });
      },

      handleTaskError: (data) => {
        set((state) => ({
          tasks: state.tasks.map((t) =>
            t.id === data.taskId
              ? { ...t, status: 'error', error: data.error }
              : t
          ),
        }));
        get().addLogEntry({
          id: Date.now().toString(),
          timestamp: new Date(),
          type: 'error',
          message: `Task failed: ${data.error}`,
          taskId: data.taskId,
        });
      },
    })),
    { name: 'workflow-store' }
  )
);