import { CalendarDays, Clock, Scissors, User } from 'lucide-react';

export default function App() {
  return (
    <div className="min-h-screen flex flex-col items-center p-6 bg-barber-dark">
      {/* Header */}
      <header className="w-full max-w-md text-center mb-10 mt-8">
        <h1 className="text-3xl font-bold tracking-tight text-barber-light">
          Trato <span className="text-barber-gold">Fino</span>
        </h1>
        <p className="text-zinc-400 mt-2 text-sm">Agende seu horário com nossos especialistas</p>
      </header>

      <main className="w-full max-w-md space-y-6">
        {/* Card de Serviço */}
        <section className="bg-barber-gray p-5 rounded-2xl border border-zinc-800 transition-all hover:border-barber-gold/50 cursor-pointer">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-zinc-900 rounded-xl text-barber-gold">
                <Scissors size={24} />
              </div>
              <div>
                <h3 className="font-semibold text-lg">Corte + Barba</h3>
                <p className="text-zinc-400 text-sm">Duração: ~60 min</p>
              </div>
            </div>
            <span className="text-barber-gold font-bold">R$ 75</span>
          </div>
        </section>

        {/* Card de Profissional */}
        <section className="bg-barber-gray p-5 rounded-2xl border border-zinc-800">
          <h2 className="text-sm font-medium text-zinc-400 mb-4 uppercase tracking-wider flex items-center gap-2">
            <User size={16} /> Profissional
          </h2>
          <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
            {['Qualquer', 'Diego', 'Carlos'].map((nome, i) => (
              <button
                key={nome}
                className={`flex-shrink-0 px-6 py-3 rounded-xl font-medium transition-colors ${
                  i === 1 
                    ? 'bg-barber-gold text-zinc-950' 
                    : 'bg-zinc-900 text-zinc-300 hover:bg-zinc-800'
                }`}
              >
                {nome}
              </button>
            ))}
          </div>
        </section>

        {/* Card de Data e Hora */}
        <section className="bg-barber-gray p-5 rounded-2xl border border-zinc-800">
          <div className="flex gap-4 mb-4">
            <div className="flex-1">
              <h2 className="text-sm font-medium text-zinc-400 mb-3 uppercase tracking-wider flex items-center gap-2">
                <CalendarDays size={16} /> Data
              </h2>
              <input 
                type="date" 
                className="w-full bg-zinc-900 text-barber-light border border-zinc-800 rounded-xl p-3 focus:outline-none focus:border-barber-gold focus:ring-1 focus:ring-barber-gold"
              />
            </div>
          </div>
          
          <h2 className="text-sm font-medium text-zinc-400 mb-3 uppercase tracking-wider flex items-center gap-2">
            <Clock size={16} /> Horários Disponíveis
          </h2>
          <div className="grid grid-cols-4 gap-2">
            {['09:00', '09:30', '10:00', '10:30', '11:00'].map((hora) => (
              <button
                key={hora}
                className="py-2 bg-zinc-900 border border-zinc-800 rounded-lg text-sm text-zinc-300 hover:border-barber-gold transition-colors"
              >
                {hora}
              </button>
            ))}
          </div>
        </section>

        {/* Botão de Ação */}
        <button className="w-full bg-barber-gold hover:bg-barber-goldHover text-zinc-950 font-bold text-lg py-4 rounded-xl transition-all shadow-[0_0_20px_rgba(212,175,55,0.2)]">
          Confirmar Agendamento
        </button>
      </main>
    </div>
  );
}