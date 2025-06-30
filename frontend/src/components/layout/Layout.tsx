import type { ReactNode } from 'react'
import Header from './Header'
import Footer from './Footer'
import Main from './Main'

type Props = {
  children: ReactNode
}

export default function Layout({ children }: Props) {
  return (
    <div className="min-h-screen flex flex-col">
      <Header />
      <Main>{children}</Main>
      <Footer />
    </div>
  )
}