import { useEffect, useState } from 'react'
import { useAuth } from '../hooks/use-auth'
import { useApi } from '../hooks/userApi'
import type { User } from '../types/User'
import { UserList } from '../components/users/UserList'

export default function Users() {
  const { apiFetch } = useApi()
  const { authHeaders } = useAuth()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const data = await apiFetch<{ data: { attributes: User }[] }>(
          `${import.meta.env.VITE_API_URL}/api/v1/users`, {
          headers: {
            Authorization: authHeaders?.authorization || '',
            'Content-Type': 'application/json',
          },
        })

        if (data) {
          setUsers(data.data.map((item) => item.attributes))
        }

        // if (!response.ok) {
        //   throw new Error('Erro ao buscar usuários')
        // }

        // const data_json: ApiResponse = await response.json()
        // const users = data_json.data.map((item => item.attributes))
      } catch (error) {
        console.error(error)
      } finally {
        setLoading(false)
      }
    }

    if (authHeaders?.authorization) {
      fetchUsers()
    }
  }, [authHeaders, apiFetch])

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
