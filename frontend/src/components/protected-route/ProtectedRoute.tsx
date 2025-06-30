import { Navigate } from 'react-router-dom'
import { useAuth } from '../../hooks/use-auth'
import type { JSX } from 'react'

export function ProtectedRoute({ children }: { children: JSX.Element }) {
  const { user } = useAuth()

  if (!user) {
    return <Navigate to="/login" replace />
  }

  return children
}
