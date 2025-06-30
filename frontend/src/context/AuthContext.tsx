import { useState, useEffect } from 'react'
import type { ReactNode } from 'react'
import { AuthContext } from './auth-context'

type User = {
  name: string
  email: string
  role: string
}
type AuthHeaders = {
  authorization: string
}
export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(() => {
    const storedUser = localStorage.getItem('user')
    return storedUser ? JSON.parse(storedUser) : null
  })

  const [authHeaders, setAuthHeaders] = useState<AuthHeaders | null>(() => {
    const stored = localStorage.getItem('authHeaders')
    return stored ? JSON.parse(stored) : null
  })

  useEffect(() => {
    if (user) {
      localStorage.setItem('user', JSON.stringify(user))
    } else {
      localStorage.removeItem('user')
    }
  }, [user])

  useEffect(() => {
    if (authHeaders) {
      localStorage.setItem('authHeaders', JSON.stringify(authHeaders))
    } else {
      localStorage.removeItem('authHeaders')
    }
  }, [authHeaders])

  const logout = () => {
    setUser(null)
    setAuthHeaders(null)
    localStorage.removeItem('user')
    localStorage.removeItem('authHeaders')
  }

  return (
    <AuthContext.Provider value={{ user, setUser, authHeaders, setAuthHeaders, logout }}>
      {children}
    </AuthContext.Provider>
  )
}
