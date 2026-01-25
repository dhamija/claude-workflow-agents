/**
 * Retry logic with exponential backoff
 */

export interface RetryOptions {
  maxAttempts?: number;
  delayMs?: number;
  backoff?: 'linear' | 'exponential';
  onRetry?: (attempt: number, error: Error) => void;
}

/**
 * Retry a function with configurable backoff strategy
 */
export async function withRetry<T>(
  fn: () => Promise<T>,
  options: RetryOptions = {}
): Promise<T> {
  const {
    maxAttempts = 3,
    delayMs = 1000,
    backoff = 'exponential',
    onRetry,
  } = options;

  let lastError: Error;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;

      if (attempt < maxAttempts) {
        // Calculate delay based on backoff strategy
        const delay = backoff === 'exponential'
          ? delayMs * Math.pow(2, attempt - 1)
          : delayMs * attempt;

        // Call onRetry callback if provided
        if (onRetry) {
          onRetry(attempt, lastError);
        }

        // Wait before retrying
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  }

  throw lastError!;
}

/**
 * Retry with specific error handling
 *
 * Allows different handling for different error types
 */
export async function withRetryAndErrorHandling<T>(
  fn: () => Promise<T>,
  options: RetryOptions & {
    shouldRetry?: (error: Error, attempt: number) => boolean;
  } = {}
): Promise<T> {
  const {
    maxAttempts = 3,
    delayMs = 1000,
    backoff = 'exponential',
    onRetry,
    shouldRetry = () => true,
  } = options;

  let lastError: Error;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;

      // Check if we should retry this error
      const retry = attempt < maxAttempts && shouldRetry(lastError, attempt);

      if (retry) {
        const delay = backoff === 'exponential'
          ? delayMs * Math.pow(2, attempt - 1)
          : delayMs * attempt;

        if (onRetry) {
          onRetry(attempt, lastError);
        }

        await new Promise(resolve => setTimeout(resolve, delay));
      } else {
        break; // Don't retry
      }
    }
  }

  throw lastError!;
}
