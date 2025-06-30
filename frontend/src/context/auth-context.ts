import { createContext } from 'react'

type User = {
  name: string
  email: string
  role: string
}

type AuthHeaders = {
  authorization: string
}

type AuthContextType = {
  user: User | null
  authHeaders: AuthHeaders | null
  setUser: (user: User | null) => void
  setAuthHeaders: (headers: AuthHeaders | null) => void
  logout: () => void
}

export const AuthContext = createContext<AuthContextType | undefined>(undefined)
