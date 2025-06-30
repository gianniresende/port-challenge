import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import Home from './pages/Home'
import Login from './pages/Login'
import Users from './pages/Users'
import { AuthProvider } from './context/AuthContext'
import { ProtectedRoute } from './components/protected-route/ProtectedRoute'
import { ProtectedLayout } from './components/protected-layout/ProtectedLayout'

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <ProtectedLayout>
                  <Home />
                </ProtectedLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/users"
            element={
              <ProtectedLayout>
                <Users />
              </ProtectedLayout>
            }
          />
        </Routes>
      </Router>
    </AuthProvider>
  )
}

export default App