import { json } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import { useEffect, useState } from "react";
import { FaCoffee, FaStore, FaCalendar } from "react-icons/fa";
import axios from "axios";

export async function loader() {
  try {
    const menuResponse = await axios.get('http://127.0.0.1:4567/menu');
    return json({ menu: menuResponse.data });
  } catch (error) {
    console.error('Error fetching menu:', error);
    return json({ menu: [] });
  }
}

export default function Index() {
  const { menu } = useLoaderData<typeof loader>();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    date: '',
    time: '',
    guests: '1'
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await axios.post('http://127.0.0.1:4567/reservations', formData);
      alert('Réservation confirmée !');
      setFormData({ name: '', email: '', date: '', time: '', guests: '1' });
    } catch (error) {
      console.error('Error making reservation:', error);
      alert('Erreur lors de la réservation. Veuillez réessayer.');
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-[#1e3932] text-white py-6 shadow-lg">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <FaCoffee className="text-2xl" />
              <h1 className="text-3xl font-bold">Café de L'avenir</h1>
            </div>
            <nav className="hidden md:flex gap-6">
              <a href="#menu" className="hover:text-green-200 transition-colors">Menu</a>
              <a href="#reservation" className="hover:text-green-200 transition-colors">Réservation</a>
            </nav>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-12">
        <section id="menu" className="mb-16">
          <div className="text-center mb-12">
            <h2 className="text-4xl font-bold text-[#1e3932] mb-4">Notre Menu</h2>
            <p className="text-gray-600">Découvrez nos délicieuses boissons et nos plats raffinés</p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {menu.map((item: any) => (
              <div key={item.id} className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-shadow">
                <div className="p-6">
                  <h3 className="text-xl font-bold text-[#1e3932] mb-2">{item.name}</h3>
                  <p className="text-gray-600 mb-4">{item.description}</p>
                  <div className="flex justify-between items-center">
                    <span className="text-lg font-bold text-[#1e3932]">{item.price}€</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        <section id="reservation" className="bg-white rounded-xl shadow-lg p-8 max-w-2xl mx-auto">
          <div className="text-center mb-8">
            <FaCalendar className="text-4xl text-[#1e3932] mx-auto mb-4" />
            <h2 className="text-3xl font-bold text-[#1e3932]">Réservation</h2>
            <p className="text-gray-600 mt-2">Réservez votre table en quelques clics</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700">Nom</label>
              <input
                type="text"
                id="name"
                name="name"
                value={formData.name}
                onChange={handleChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-[#1e3932] focus:ring focus:ring-[#1e3932] focus:ring-opacity-50"
                required
              />
            </div>

            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email</label>
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-[#1e3932] focus:ring focus:ring-[#1e3932] focus:ring-opacity-50"
                required
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="date" className="block text-sm font-medium text-gray-700">Date</label>
                <input
                  type="date"
                  id="date"
                  name="date"
                  value={formData.date}
                  onChange={handleChange}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-[#1e3932] focus:ring focus:ring-[#1e3932] focus:ring-opacity-50"
                  required
                />
              </div>

              <div>
                <label htmlFor="time" className="block text-sm font-medium text-gray-700">Heure</label>
                <select
                  id="time"
                  name="time"
                  value={formData.time}
                  onChange={handleChange}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-[#1e3932] focus:ring focus:ring-[#1e3932] focus:ring-opacity-50"
                  required
                >
                  <option value="">Choisir une heure</option>
                  {["12:00", "12:30", "13:00", "13:30", "19:00", "19:30", "20:00", "20:30"].map((time) => (
                    <option key={time} value={time}>{time}</option>
                  ))}
                </select>
              </div>
            </div>

            <div>
              <label htmlFor="guests" className="block text-sm font-medium text-gray-700">
                Nombre de personnes
              </label>
              <select
                id="guests"
                name="guests"
                value={formData.guests}
                onChange={handleChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-[#1e3932] focus:ring focus:ring-[#1e3932] focus:ring-opacity-50"
                required
              >
                {[1, 2, 3, 4, 5, 6, 7, 8].map((num) => (
                  <option key={num} value={num}>
                    {num} {num === 1 ? 'personne' : 'personnes'}
                  </option>
                ))}
              </select>
            </div>

            <button
              type="submit"
              className="w-full bg-[#1e3932] text-white py-3 px-4 rounded-md hover:bg-[#2d5548] transition-colors font-medium"
            >
              Réserver ma table
            </button>
          </form>
        </section>
      </main>

      <footer className="bg-[#1e3932] text-white py-8 mt-16">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="flex items-center gap-2 mb-4 md:mb-0">
              <FaStore className="text-2xl" />
              <h2 className="text-xl font-bold">Café de L'avenir</h2>
            </div>
            <div className="text-center md:text-right">
              <p>123 Rue du Futur, 75001 Paris</p>
              <p className="mt-2">Ouvert du mardi au dimanche, de 8h à 22h</p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}