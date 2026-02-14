/**
 * Unit tests for workflow store
 */

import { describe, it, expect, beforeEach, vi } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useWorkflowStore } from '@/stores/workflowStore';
import { workflowApi } from '@/services/api';

// Mock the API
vi.mock('@/services/api', () => ({
  workflowApi: {
    getState: vi.fn(),
    getArtifacts: vi.fn(),
    getGaps: vi.fn(),
    getTasks: vi.fn(),
    getActivityLog: vi.fn(),
    checkClaudeConnection: vi.fn(),
    regenerateArtifact: vi.fn(),
    createEnhancement: vi.fn(),
  },
}));

// Mock websocket
vi.mock('@/services/websocket', () => ({
  websocket: {
    connect: vi.fn(),
    on: vi.fn(),
    off: vi.fn(),
    sendCommand: vi.fn(),
  },
}));

describe('WorkflowStore', () => {
  beforeEach(() => {
    // Reset store state
    useWorkflowStore.setState({
      workflowState: null,
      artifacts: [],
      gaps: [],
      tasks: [],
      activityLog: [],
      isLoading: false,
      error: null,
    });

    // Reset all mocks
    vi.clearAllMocks();
  });

  describe('initialization', () => {
    it('should fetch all data on initialize', async () => {
      // Mock API responses
      const mockState = {
        version: '3.8',
        type: 'greenfield' as const,
        phase: 'L1' as const,
        status: 'in_progress' as const,
        mode: 'auto' as const,
        lastUpdated: new Date(),
      };

      const mockArtifacts = [
        {
          type: 'intent' as const,
          version: 'v2.0',
          status: 'current' as const,
          lastModified: new Date(),
          path: '/docs/intent/product-intent.md',
          items: [],
          canRegenerate: true,
        },
      ];

      vi.mocked(workflowApi.getState).mockResolvedValue(mockState);
      vi.mocked(workflowApi.getArtifacts).mockResolvedValue(mockArtifacts);
      vi.mocked(workflowApi.getGaps).mockResolvedValue([]);
      vi.mocked(workflowApi.getTasks).mockResolvedValue([]);
      vi.mocked(workflowApi.getActivityLog).mockResolvedValue([]);
      vi.mocked(workflowApi.checkClaudeConnection).mockResolvedValue({
        connected: true,
        mode: 'integrated',
      });

      const { result } = renderHook(() => useWorkflowStore());

      await act(async () => {
        await result.current.initialize();
      });

      expect(result.current.workflowState).toEqual(mockState);
      expect(result.current.artifacts).toEqual(mockArtifacts);
      expect(result.current.claudeConnected).toBe(true);
      expect(result.current.mode).toBe('integrated');
    });

    it('should handle initialization errors', async () => {
      const error = new Error('Network error');
      vi.mocked(workflowApi.getState).mockRejectedValue(error);

      const { result } = renderHook(() => useWorkflowStore());

      await act(async () => {
        await result.current.initialize();
      });

      expect(result.current.error).toBe('Network error');
      expect(result.current.isLoading).toBe(false);
    });
  });

  describe('artifact operations', () => {
    it('should regenerate an artifact', async () => {
      const mockTask = {
        id: 'task-1',
        type: 'regenerate' as const,
        description: 'Regenerating intent artifact',
        status: 'pending' as const,
        createdAt: new Date(),
      };

      vi.mocked(workflowApi.regenerateArtifact).mockResolvedValue(mockTask);

      const { result } = renderHook(() => useWorkflowStore());

      // Set initial artifacts
      result.current.artifacts = [
        {
          type: 'intent',
          version: 'v1.0',
          status: 'current',
          lastModified: new Date(),
          path: '/docs/intent/product-intent.md',
          items: [],
          canRegenerate: true,
        },
      ];

      await act(async () => {
        await result.current.regenerateArtifact('intent', 'evolve');
      });

      expect(workflowApi.regenerateArtifact).toHaveBeenCalledWith('intent', 'evolve');
      expect(result.current.tasks).toContainEqual(mockTask);
      expect(result.current.artifacts[0].status).toBe('regenerating');
    });
  });

  describe('enhancement operations', () => {
    it('should create an enhancement', async () => {
      const mockEnhancement = {
        id: 'enh-1',
        description: 'Add AI features',
        affectedArtifacts: ['intent', 'ux', 'architecture'] as any,
        estimatedTime: 300,
        status: 'pending' as const,
        createdAt: new Date(),
      };

      vi.mocked(workflowApi.createEnhancement).mockResolvedValue(mockEnhancement);

      const { result } = renderHook(() => useWorkflowStore());

      await act(async () => {
        await result.current.createEnhancement('Add AI features');
      });

      expect(workflowApi.createEnhancement).toHaveBeenCalledWith('Add AI features');
      expect(result.current.currentEnhancement).toEqual(mockEnhancement);
      expect(result.current.activityLog).toHaveLength(1);
      expect(result.current.activityLog[0].message).toContain('Enhancement created');
    });
  });

  describe('activity log', () => {
    it('should add log entries', () => {
      const { result } = renderHook(() => useWorkflowStore());

      const entry = {
        id: '1',
        timestamp: new Date(),
        type: 'info' as const,
        message: 'Test message',
      };

      act(() => {
        result.current.addLogEntry(entry);
      });

      expect(result.current.activityLog).toContainEqual(entry);
    });

    it('should limit activity log to 100 entries', () => {
      const { result } = renderHook(() => useWorkflowStore());

      act(() => {
        for (let i = 0; i < 110; i++) {
          result.current.addLogEntry({
            id: i.toString(),
            timestamp: new Date(),
            type: 'info',
            message: `Message ${i}`,
          });
        }
      });

      expect(result.current.activityLog).toHaveLength(100);
    });

    it('should clear activity log', () => {
      const { result } = renderHook(() => useWorkflowStore());

      act(() => {
        result.current.addLogEntry({
          id: '1',
          timestamp: new Date(),
          type: 'info',
          message: 'Test',
        });
        result.current.clearActivityLog();
      });

      expect(result.current.activityLog).toHaveLength(0);
    });
  });
});