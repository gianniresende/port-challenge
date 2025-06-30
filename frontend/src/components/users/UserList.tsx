import type { User } from '../../types/User'

type UserListProps = {
  users: User[]
}

export function UserList({ users }: UserListProps) {
  return (
    <ul className="space-y-2">
      {users.map((user) => (
        <li key={user.id} className="border p-4 rounded shadow-sm">
          <p><strong>Nome:</strong> {user.name}</p>
          <p><strong>Email:</strong> {user.email}</p>
          <p><strong>Perfil:</strong> {user.role}</p>
        </li>
      ))}
    </ul>
  )
}

