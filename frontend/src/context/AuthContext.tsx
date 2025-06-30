import { useState } from 'react'
import type { ReactNode } from 'react'
import { AuthContext } from './auth-context'

type User = {
  name: string
  email: string
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)

  return (
    <AuthContext.Provider value={{ user, setUser }}>
      {children}
    </AuthContext.Provider>
  )
}