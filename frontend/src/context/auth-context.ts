import { createContext } from 'react'

type User = {
  name: string
  email: string
}

type AuthContextType = {
  user: User | null
  setUser: (user: User | null) => void
}

export const AuthContext = createContext<AuthContextType | undefined>(undefined)
