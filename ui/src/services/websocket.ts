/**
 * WebSocket service for real-time updates
 */

import { io, Socket } from 'socket.io-client';
import type { Task, ActivityLogEntry, ArtifactState } from '@/types/workflow';

export type WebSocketEvent =
  | { type: 'task:progress'; data: { taskId: string; progress: number } }
  | { type: 'task:complete'; data: Task }
  | { type: 'task:error'; data: { taskId: string; error: string } }
  | { type: 'artifact:updated'; data: ArtifactState }
  | { type: 'activity:log'; data: ActivityLogEntry }
  | { type: 'claude:connected' }
  | { type: 'claude:disconnected' };

class WebSocketService {
  private socket: Socket | null = null;
  private listeners: Map<string, Set<(data: any) => void>> = new Map();

  connect(url: string = 'http://localhost:4000') {
    if (this.socket?.connected) {
      return;
    }

    this.socket = io(url, {
      reconnection: true,
      reconnectionDelay: 1000,
      reconnectionAttempts: 5,
    });

    // Set up event listeners
    this.socket.on('connect', () => {
      console.log('WebSocket connected');
      this.emit('connected', null);
    });

    this.socket.on('disconnect', () => {
      console.log('WebSocket disconnected');
      this.emit('disconnected', null);
    });

    // Workflow events
    this.socket.on('task:progress', (data) => {
      this.emit('task:progress', data);
    });

    this.socket.on('task:complete', (data) => {
      this.emit('task:complete', data);
    });

    this.socket.on('task:error', (data) => {
      this.emit('task:error', data);
    });

    this.socket.on('artifact:updated', (data) => {
      this.emit('artifact:updated', data);
    });

    this.socket.on('activity:log', (data) => {
      this.emit('activity:log', data);
    });

    this.socket.on('claude:connected', () => {
      this.emit('claude:connected', null);
    });

    this.socket.on('claude:disconnected', () => {
      this.emit('claude:disconnected', null);
    });
  }

  disconnect() {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
    }
  }

  on<T = any>(event: string, callback: (data: T) => void) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Set());
    }
    this.listeners.get(event)!.add(callback);

    // Return unsubscribe function
    return () => {
      this.listeners.get(event)?.delete(callback);
    };
  }

  off(event: string, callback?: (data: any) => void) {
    if (callback) {
      this.listeners.get(event)?.delete(callback);
    } else {
      this.listeners.delete(event);
    }
  }

  private emit(event: string, data: any) {
    this.listeners.get(event)?.forEach(callback => {
      callback(data);
    });
  }

  // Send commands to backend
  sendCommand(command: string, args?: any) {
    if (this.socket?.connected) {
      this.socket.emit('command', { command, args });
    } else {
      console.error('WebSocket not connected');
    }
  }

  // Request specific updates
  requestUpdate(type: 'state' | 'artifacts' | 'tasks' | 'gaps') {
    if (this.socket?.connected) {
      this.socket.emit('request:update', { type });
    }
  }
}

// Singleton instance
export const websocket = new WebSocketService();

export default websocket;