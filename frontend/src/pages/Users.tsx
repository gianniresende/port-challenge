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
  const [filters, setFilters] = useState({
    name: '',
    role: '',
    order_by: 'created_at',
    order: 'desc',
    page: 1,
    per_page: 10,
  })

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const query = new URLSearchParams()
        if (filters.name) query.append('name', filters.name)
        if (filters.role) query.append('role', filters.role)
        query.append('order_by', filters.order_by)
        query.append('order', filters.order)
        query.append('page', String(filters.page))
        query.append('per_page', String(filters.per_page))

        const data = await apiFetch<{ data: { attributes: User }[] }>(
          `${import.meta.env.VITE_API_URL}/api/v1/users?${query.toString()}`, {
          headers: {
            Authorization: authHeaders?.authorization || '',
            'Content-Type': 'application/json',
          },
        })

        if (data) {
          setUsers(data.data.map((item) => item.attributes))
        }

      } catch (error) {
        console.error(error)
      } finally {
        setLoading(false)
      }
    }

    if (authHeaders?.authorization) {
      fetchUsers()
    }
  }, [authHeaders, filters, apiFetch])

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-center mb-4">Usuários</h1>
      {loading ? (
        <p className="text-center text-gray-500">Carregando...</p>
      ) : (
        <UserList
        users={users}
        loading={loading}
        filters={filters}
        setFilters={setFilters}
      />
      )}
    </div>
  )
}
