import { useAuth } from '../hooks/use-auth'
import { useNavigate } from 'react-router-dom'

export function useApi() {
  const { authHeaders, logout } = useAuth()
  const navigate = useNavigate()

  async function apiFetch<T = unknown>(
    input: RequestInfo,
    init: RequestInit = {}
  ): Promise<T | null> {
    const headers = {
      ...init.headers,
      Authorization: authHeaders?.authorization || '',
      'Content-Type': 'application/json',
    }

    const response = await fetch(input, { ...init, headers })

    if (response.status === 401) {
      logout()
      navigate('/login')
      return null
    }

    if (!response.ok) {
      throw new Error(`Erro: ${response.status}`)
    }

    return response.json()
  }

  return { apiFetch }
}
