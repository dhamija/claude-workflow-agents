/**
 * Core workflow types for the UI
 */

export type WorkflowPhase = 'L1' | 'L2';
export type ArtifactType = 'intent' | 'ux' | 'architecture' | 'plan';
export type ImplementationPhase = 'backend' | 'frontend' | 'tests' | 'validation';

export interface WorkflowState {
  version: string;
  type: 'greenfield' | 'brownfield';
  phase: WorkflowPhase;
  status: 'not_started' | 'in_progress' | 'paused' | 'complete';
  mode: 'auto' | 'manual';
  lastUpdated: Date;
}

export interface ArtifactState {
  type: ArtifactType;
  version: string;
  status: 'current' | 'outdated' | 'regenerating' | 'error';
  lastModified: Date;
  path: string;
  content?: string;
  items: ArtifactItem[];
  canRegenerate: boolean;
  gitStatus?: 'clean' | 'modified' | 'untracked';
}

export interface ArtifactItem {
  id: string;
  name: string;
  status: 'complete' | 'in_progress' | 'pending' | 'new';
  isNew?: boolean;
  description?: string;
}

export interface ImplementationState {
  phase: ImplementationPhase;
  progress: number;
  status: 'not_started' | 'in_progress' | 'complete' | 'paused' | 'error';
  currentTask?: string;
  errors?: string[];
}

export interface Gap {
  id: string;
  type: 'R' | 'U' | 'A' | 'I'; // Reality, User, Analysis, Infrastructure
  number: number;
  title: string;
  category: 'functionality' | 'ux' | 'architecture' | 'performance' | 'security' | 'infrastructure';
  severity: 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW';
  status: 'open' | 'in_progress' | 'fixed' | 'verified' | 'closed';
  evidence?: string;
  fix?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Enhancement {
  id: string;
  description: string;
  affectedArtifacts: ArtifactType[];
  estimatedTime: number;
  status: 'pending' | 'analyzing' | 'approved' | 'in_progress' | 'complete';
  createdAt: Date;
}

export interface Task {
  id: string;
  type: 'enhancement' | 'regenerate' | 'fix_gap' | 'validate';
  description: string;
  artifacts?: ArtifactType[];
  commands?: string[];
  status: 'pending' | 'in_progress' | 'complete' | 'error';
  progress?: number;
  output?: string[];
  error?: string;
  createdAt: Date;
  startedAt?: Date;
  completedAt?: Date;
}

export interface ActivityLogEntry {
  id: string;
  timestamp: Date;
  type: 'info' | 'success' | 'warning' | 'error';
  message: string;
  details?: any;
  taskId?: string;
  artifactType?: ArtifactType;
}