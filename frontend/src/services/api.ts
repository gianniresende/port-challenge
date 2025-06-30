const API_URL = import.meta.env.VITE_API_URL;

export const api = {
  async login(email: string, password: string) {
    const response = await fetch(`${API_URL}/auth/sign_in`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email, password }),
    });

    if (!response.ok) {
      throw new Error('Erro ao fazer login');
    }

    return response.json();
  },
};
