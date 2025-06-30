import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/use-auth'
import { LoginForm } from '../components/login/LoginForm'

export default function Login() {
  const { user, setUser } = useAuth()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    if (user) {
      navigate('/', { replace: true })
    }
  }, [user, navigate])

  const handleLogin = async (email: string, password: string) => {
    setError('')
    setLoading(true)

    try {
      const response = await fetch(`${import.meta.env.VITE_API_URL}/auth/sign_in`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      })

      if (!response.ok) {
        throw new Error('Email ou senha inválidos')
      }

      const data = await response.json()
      const headers = {
        'access-token': response.headers.get('access-token'),
        client: response.headers.get('client'),
        uid: response.headers.get('uid'),
        authorization: response.headers.get('authorization'),
      }

      setUser({ ...data.data, ...headers })
      navigate('/', { replace: true })

    } catch (error: unknown) {
      if (error instanceof Error) {
        setError(error.message)
      } else {
        setError('Erro desconhecido')
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <LoginForm onSubmit={handleLogin} loading={loading} error={error} />
    </div>
  )
}
