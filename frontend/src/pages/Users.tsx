import { useEffect, useState } from 'react'
import { UserList } from '../components/users/UserList'
import { useAuth } from '../hooks/use-auth'
import type { User } from '../types/User'

type ApiUser = {
  id: string
  type: string
  attributes: User
}
type ApiResponse = {
  data: ApiUser[]
}

export default function Users() {
  const { authHeaders } = useAuth()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await fetch(`${import.meta.env.VITE_API_URL}/api/v1/users`, {
          headers: {
            Authorization: authHeaders?.authorization || '',
            'Content-Type': 'application/json',
          },
        })

        if (!response.ok) {
          throw new Error('Erro ao buscar usuários')
        }

        const data_json: ApiResponse = await response.json()
        const users = data_json.data.map((item => item.attributes))
        setUsers(users)
      } catch (error) {
        console.error(error)
      } finally {
        setLoading(false)
      }
    }

    if (authHeaders?.authorization) {
      fetchUsers()
    }
  }, [authHeaders])

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-center mb-4">Usuários</h1>
      {loading ? (
        <p className="text-center text-gray-500">Carregando...</p>
      ) : (
        <UserList users={users} />
      )}
    </div>
  )
}
