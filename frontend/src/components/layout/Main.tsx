import type { ReactNode } from 'react'

type Props = {
  children: ReactNode
}

export default function Main({ children }: Props) {
  return <main className="flex-1 p-4">{children}</main>
}