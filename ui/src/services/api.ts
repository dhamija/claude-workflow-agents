/**
 * API service for workflow operations
 */

import axios from 'axios';
import type {
  WorkflowState,
  ArtifactState,
  ImplementationState,
  Gap,
  Enhancement,
  Task,
  ActivityLogEntry,
  ArtifactType,
} from '@/types/workflow';

const API_BASE_URL = import.meta.env.VITE_API_URL || '/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor for auth
api.interceptors.request.use((config) => {
  // Add auth token if available
  const token = localStorage.getItem('workflow_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized
      localStorage.removeItem('workflow_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export const workflowApi = {
  // State Management
  async getState(): Promise<WorkflowState> {
    const { data } = await api.get<WorkflowState>('/workflow/state');
    return data;
  },

  async getArtifacts(): Promise<ArtifactState[]> {
    const { data } = await api.get<ArtifactState[]>('/workflow/artifacts');
    return data;
  },

  async getArtifact(type: ArtifactType): Promise<ArtifactState> {
    const { data } = await api.get<ArtifactState>(`/workflow/artifacts/${type}`);
    return data;
  },

  async getImplementation(): Promise<ImplementationState[]> {
    const { data } = await api.get<ImplementationState[]>('/workflow/implementation');
    return data;
  },

  // Enhancements
  async createEnhancement(description: string): Promise<Enhancement> {
    const { data } = await api.post<Enhancement>('/workflow/enhance', {
      description,
    });
    return data;
  },

  async approveEnhancement(id: string): Promise<Task> {
    const { data } = await api.post<Task>(`/workflow/enhance/${id}/approve`);
    return data;
  },

  // Artifact Operations
  async regenerateArtifact(type: ArtifactType, mode: 'evolve' | 'replace' = 'evolve'): Promise<Task> {
    const { data } = await api.post<Task>(`/workflow/artifacts/${type}/regenerate`, {
      mode,
    });
    return data;
  },

  async editArtifact(type: ArtifactType, content: string): Promise<ArtifactState> {
    const { data } = await api.put<ArtifactState>(`/workflow/artifacts/${type}`, {
      content,
    });
    return data;
  },

  // Gap Management
  async getGaps(): Promise<Gap[]> {
    const { data } = await api.get<Gap[]>('/workflow/gaps');
    return data;
  },

  async fixGap(id: string): Promise<Task> {
    const { data } = await api.post<Task>(`/workflow/gaps/${id}/fix`);
    return data;
  },

  async verifyGap(id: string): Promise<Task> {
    const { data } = await api.post<Task>(`/workflow/gaps/${id}/verify`);
    return data;
  },

  // Task Management
  async getTasks(): Promise<Task[]> {
    const { data } = await api.get<Task[]>('/workflow/tasks');
    return data;
  },

  async getTask(id: string): Promise<Task> {
    const { data } = await api.get<Task>(`/workflow/tasks/${id}`);
    return data;
  },

  async cancelTask(id: string): Promise<void> {
    await api.delete(`/workflow/tasks/${id}`);
  },

  // Activity Log
  async getActivityLog(limit: number = 100): Promise<ActivityLogEntry[]> {
    const { data } = await api.get<ActivityLogEntry[]>('/workflow/activity', {
      params: { limit },
    });
    return data;
  },

  // Claude Integration
  async checkClaudeConnection(): Promise<{ connected: boolean; mode: 'integrated' | 'standalone' }> {
    try {
      const { data } = await api.get('/claude/status');
      return { connected: true, mode: 'integrated' };
    } catch {
      return { connected: false, mode: 'standalone' };
    }
  },

  async sendToClau(command: string): Promise<Task> {
    const { data } = await api.post<Task>('/claude/execute', { command });
    return data;
  },
};

export default workflowApi;