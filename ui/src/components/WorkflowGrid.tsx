/**
 * Main workflow grid component
 */

import React from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@radix-ui/react-tabs';
import { useWorkflowStore } from '@/stores/workflowStore';
import { ArtifactCard } from './ArtifactCard';
import { ImplementationPanel } from './ImplementationPanel';
import { ActivityLog } from './ActivityLog';
import { EnhancementDialog } from './EnhancementDialog';
import { GapsList } from './GapsList';
import { Button } from './ui/Button';
import {
  Plus,
  Play,
  RefreshCw,
  CheckCircle,
  AlertCircle,
  Zap
} from 'lucide-react';

export function WorkflowGrid() {
  const {
    workflowState,
    artifacts,
    implementation,
    gaps,
    activityLog,
    claudeConnected,
    mode,
    isLoading,
    error,
  } = useWorkflowStore();

  const [enhancementOpen, setEnhancementOpen] = React.useState(false);

  return (
    <div className="h-screen flex flex-col bg-gray-50 dark:bg-gray-900">
      {/* Header */}
      <header className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
              Workflow Control Center
            </h1>
            {workflowState && (
              <div className="flex items-center space-x-2 text-sm">
                <span className="text-gray-500">Project:</span>
                <span className="font-medium text-gray-900 dark:text-white">
                  {workflowState.type === 'greenfield' ? 'New' : 'Existing'}
                </span>
                <span className="text-gray-500">•</span>
                <span className="text-gray-500">Version:</span>
                <span className="font-medium text-gray-900 dark:text-white">
                  {workflowState.version}
                </span>
              </div>
            )}
          </div>

          <div className="flex items-center space-x-3">
            {/* Claude Connection Status */}
            <div className="flex items-center space-x-2">
              {claudeConnected ? (
                <CheckCircle className="w-5 h-5 text-green-500" />
              ) : (
                <AlertCircle className="w-5 h-5 text-yellow-500" />
              )}
              <span className="text-sm text-gray-600 dark:text-gray-400">
                Claude: {mode === 'integrated' ? 'Connected' : 'Standalone'}
              </span>
            </div>

            {/* Action Buttons */}
            <Button
              onClick={() => setEnhancementOpen(true)}
              className="flex items-center space-x-2"
              variant="primary"
            >
              <Plus className="w-4 h-4" />
              <span>Add Enhancement</span>
            </Button>

            <Button
              onClick={() => useWorkflowStore.getState().initialize()}
              className="flex items-center space-x-2"
              variant="secondary"
            >
              <RefreshCw className="w-4 h-4" />
              <span>Refresh</span>
            </Button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="flex-1 overflow-hidden">
        <Tabs defaultValue="workflow" className="h-full">
          <TabsList className="px-6 py-2 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
            <TabsTrigger value="workflow" className="px-4 py-2">
              Workflow
            </TabsTrigger>
            <TabsTrigger value="gaps" className="px-4 py-2">
              Gaps ({gaps.length})
            </TabsTrigger>
            <TabsTrigger value="activity" className="px-4 py-2">
              Activity Log
            </TabsTrigger>
          </TabsList>

          <TabsContent value="workflow" className="h-full p-6">
            <div className="grid grid-cols-5 gap-6 h-full">
              {/* L1 Artifacts */}
              <div className="col-span-4 grid grid-cols-4 gap-4">
                <ArtifactCard
                  artifact={artifacts.find(a => a.type === 'intent')}
                  type="intent"
                  title="Intent"
                  description="User promises and requirements"
                />
                <ArtifactCard
                  artifact={artifacts.find(a => a.type === 'ux')}
                  type="ux"
                  title="UX"
                  description="User journeys and experience"
                />
                <ArtifactCard
                  artifact={artifacts.find(a => a.type === 'architecture')}
                  type="architecture"
                  title="Architecture"
                  description="System design and modules"
                />
                <ArtifactCard
                  artifact={artifacts.find(a => a.type === 'plan')}
                  type="plan"
                  title="Plan"
                  description="Implementation phases"
                />
              </div>

              {/* L2 Implementation */}
              <div className="col-span-1">
                <ImplementationPanel implementation={implementation} />
              </div>
            </div>
          </TabsContent>

          <TabsContent value="gaps" className="h-full p-6">
            <GapsList gaps={gaps} />
          </TabsContent>

          <TabsContent value="activity" className="h-full p-6">
            <ActivityLog entries={activityLog} />
          </TabsContent>
        </Tabs>
      </div>

      {/* Enhancement Dialog */}
      <EnhancementDialog
        open={enhancementOpen}
        onClose={() => setEnhancementOpen(false)}
      />

      {/* Error Toast */}
      {error && (
        <div className="fixed bottom-4 right-4 bg-red-500 text-white px-4 py-2 rounded-md shadow-lg">
          {error}
        </div>
      )}

      {/* Loading Overlay */}
      {isLoading && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white dark:bg-gray-800 rounded-lg p-6 flex items-center space-x-3">
            <RefreshCw className="w-6 h-6 animate-spin text-blue-500" />
            <span className="text-lg">Processing...</span>
          </div>
        </div>
      )}
    </div>
  );
}