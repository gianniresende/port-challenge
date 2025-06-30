export default function Header() {
  return (
    <header className="bg-blue-600 text-white py-4 shadow">
      <div className="container mx-auto flex justify-between items-center px-4">
        <h1 className="text-xl font-bold">TeamTalk</h1>
        <nav>
          <ul className="flex gap-4">
            <li><a href="#" className="hover:underline">Usuários</a></li>
            <li><a href="#" className="hover:underline">Sobre</a></li>
          </ul>
        </nav>
      </div>
    </header>
  )
}