import { useState } from 'react'
import type { FormEvent } from 'react'

type LoginFormProps = {
  onSubmit: (email: string, password: string) => Promise<void>
  loading: boolean
  error: string
}

export function LoginForm({ onSubmit, loading, error }: LoginFormProps) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    onSubmit(email, password)
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="w-full max-w-md bg-white rounded shadow text-black p-6 space-y-4"
    >
      <h1 className="text-2xl font-bold text-center text-gray-800">Entrar no TeamTalk</h1>

      {error && <p className="text-red-600 text-sm text-center">{error}</p>}

      <div>
        <label className="block mb-1 text-sm font-medium text-gray-700">Email</label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          className="w-full border px-3 py-2 rounded shadow-sm focus:outline-none focus:ring-2 focus:ring-gray-500"
        />
      </div>

      <div>
        <label className="block mb-1 text-sm font-medium text-gray-700">Senha</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          className="w-full border px-3 py-2 rounded shadow-sm focus:outline-none focus:ring-2 focus:ring-gray-500"
        />
      </div>

      <button
        type="submit"
        disabled={loading}
        className="w-full bg-gray-600 text-white py-2 rounded hover:bg-gray-700 transition"
      >
        {loading ? 'Entrando...' : 'Entrar'}
      </button>
    </form>
  )
}
