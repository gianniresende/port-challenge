import type { User } from '../../types/User'

type UserListProps = {
  users: User[]
  loading: boolean
  filters: {
    name: string
    role: string
    order_by: string
    order: string
    page: number
    per_page: number
  }
  setFilters: (filters: UserListProps['filters']) => void
}

export function UserList({ users, loading, filters, setFilters }: UserListProps) {
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setFilters({ ...filters, [name]: value, page: 1 }) // reset page on filter change
  }

  return (
    <div>
      <div className="mb-4 flex gap-2 items-center">
        <input
          name="name"
          type="text"
          placeholder="Filtrar por nome..."
          value={filters.name}
          onChange={handleInputChange}
          className="px-4 py-2 border rounded text-gray-800 w-1/2"
        />
        <select
          name="role"
          value={filters.role}
          onChange={handleInputChange}
          className="px-3 py-2 border rounded text-gray-800"
        >
          <option value="">Todos os perfis</option>
          <option value="admin">Administrador</option>
          <option value="employee">Funcionário</option>
          <option value="manager">Gerente</option>
          <option value="hr">Recursos Humanos</option>
        </select>
      </div>

      {loading ? (
        <p className="text-gray-500 text-center">Carregando...</p>
      ) : users.length === 0 ? (
        <p className="text-gray-500 text-center">Nenhum usuário encontrado.</p>
      ) : (
        <ul className="space-y-2">
          {users.map((user) => (
            <li key={user.id} className="border p-4 rounded bg-white text-gray-800 shadow-sm">
              <p><strong>Nome:</strong> {user.name}</p>
              <p><strong>Email:</strong> {user.email}</p>
              <p><strong>Perfil:</strong> {user.role}</p>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}


