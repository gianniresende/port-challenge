import { useAuth } from '../../hooks/use-auth'
import { useNavigate, Link } from 'react-router-dom'

export default function Header() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  if (!user) return null

  return (
    <header className=" bg-gray-700 text-white py-4 shadow">
      <div className="container mx-auto flex justify-between items-center px-4">
        <h1 className="text-xl font-bold">TeamTalk</h1>
        <nav className="flex items-center gap-6">
          <ul className="flex gap-4">
            <li>
              <Link to="/users" className="hover:underline">
                Usuários
              </Link>
            </li>
          </ul>
          <button
            onClick={handleLogout}
            className="bg-white text-blue-600 px-3 py-1 rounded hover:bg-gray-100 transition"
          >
            Sair
          </button>
        </nav>
      </div>
    </header>
  )
}
