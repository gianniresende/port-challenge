import { useCallback } from 'react'
import { useAuth } from './use-auth'
import { useNavigate } from 'react-router-dom'

export function useApi() {
  const { logout } = useAuth()
  const navigate = useNavigate()

  const apiFetch = useCallback(async <T>(url: string, options: RequestInit = {}): Promise<T | null> => {
    try {
      const response = await fetch(url, options)

      if (response.status === 401) {
        logout()
        navigate('/login')
        return null
      }

      return await response.json()
    } catch (err) {
      console.error('Erro na requisição:', err)
      return null
    }
  }, [logout, navigate])

  return { apiFetch }
}

