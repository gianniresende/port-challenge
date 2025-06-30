import type { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../../hooks/use-auth'
import Header from '../../components/layout/Header'

type Props = {
  children: ReactNode
}

export function ProtectedLayout({ children }: Props) {
  const { user } = useAuth()

  if (!user) {
    return <Navigate to="/login" replace />
  }

  return (
    <>
      <Header />
      <main className="p-4">
        {children}
      </main>
    </>
  )
}
