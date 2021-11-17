import wollok.game.*
import personajes.*
import utilidades.*
import elementos.*
import enemigos.*
import nivel2.*
import nivel1.*

object nivelConEnemigos {
	
	const instructivoNivel3 = new Fondo(image = "InstructivoNivel3.png")
	 
	//se crean los enemigos
	
	var property monedasEnNivel = 0
  	var property powerUpsEnNivel = 0
  	var powerUpsEncendidos = false
  	var property enemigosEnNivel = []

	const property soundtrack = new Sound(file = "chopin_preludio4.mp3")
	
	//se crean los indicadores
	const energia = new IndicadorEnergia()
	const salud = new IndicadorSalud()

	method configurate() {
		
		//configurando protagonista
		protagonista.position(game.at(0,1))
		protagonista.salud(protagonista.salud() + 200)
		protagonista.energia(protagonista.energia() + 200)
		protagonista.image("prota_nivel3.png")
		
		game.addVisual(new Fondo())
		
		//cofres decorando
	
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
		game.addVisual(new Cofre())
	
		//se crean y se agregan las celdas
		game.addVisual(new CeldaQuitaEnergia())
		game.addVisual(new CeldaAgregaEnergia())
		game.addVisual(new CeldaTeletransportadora())
		game.addVisual(new CeldaAgregaEnergia())
		game.addVisual(new CeldaTeletransportadora())
		game.addVisual(new CeldaTeletransportadora())
		
		//se crean y se agregan monedas Sanguinarias
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
	
		// se agregan los indicadores
		game.addVisual(energia)
		game.addVisual(salud)
		
		//se agregan los enemigos
		game.addVisual(new Orco())
		game.addVisual(new Orco())
		game.addVisual(new Orco())
		game.addVisual(new Orco())
		game.addVisual(new Goblin())
		game.addVisual(new Goblin())
		
        //se agrega el prota 
		game.addVisual(protagonista)
		
		game.addVisual(instructivoNivel3)
		
		// teclado
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.q().onPressDo({game.say(self, self.enemigosEnNivel().size().toString())})
		
		keyboard.space().onPressDo({game.say(protagonista, protagonista.informarEstado())})
		
		keyboard.f().onPressDo({protagonista.interactuar()})
		
		keyboard.h().onPressDo({protagonista.lanzarEspada()})

        //otros
		keyboard.g().onPressDo({self.ganar()})
		
		keyboard.any().onPressDo({self.aparecerSalida() self.verificaFinDeNivel()})
		
		keyboard.enter().onPressDo({game.removeVisual(instructivoNivel3) self.corroborarCantidadPowerUps() self.configurarMovimientoTeclado() self.activarEnemigos()  self.reproducir() })
		
		//colisiones.
	   game.onCollideDo(protagonista, {o => protagonista.accionar(o)})
	    
	}
	
	method configurarMovimientoTeclado() {
		keyboard.up().onPressDo({ protagonista.moverArriba()
			protagonista.gastarEnergia() energia.visualizar(protagonista) salud.visualizar(protagonista) 
		})
		keyboard.down().onPressDo({ protagonista.moverAbajo()
			protagonista.gastarEnergia() energia.visualizar(protagonista) salud.visualizar(protagonista) 
		})
		keyboard.right().onPressDo({ protagonista.moverDerecha()
			protagonista.gastarEnergia() energia.visualizar(protagonista) salud.visualizar(protagonista) 
		})
		keyboard.left().onPressDo({ protagonista.moverIzquierda()
			protagonista.gastarEnergia() energia.visualizar(protagonista) salud.visualizar(protagonista) 
		})
	}

 
	method reproducir() {
		if (!self.soundtrack().played()) {
			self.soundtrack().shouldLoop(true)
			self.soundtrack().volume(0.4)
			self.soundtrack().play()
		}
	}
	
	method corroborarCantidadPowerUps() {
		game.onTick(8000, "cantidadPowerUps", { => self.detenerEIniciarPowerUps()})
	}
	
	method detenerEIniciarPowerUps() {
		if (self.powerUpsEnNivel() > 15 and powerUpsEncendidos) {
			self.detenerGeneracionDePowerUps() 
		} else if (!powerUpsEncendidos) {
			self.generarPowerUpsEnJuego()
		}
	}
	
	method detenerGeneracionDePowerUps() {
		powerUpsEncendidos = false
		game.removeTickEvent("PocionSalud")
		game.removeTickEvent("Monedas")
		game.removeTickEvent("VesselPocion")
		game.removeTickEvent("PocionMana")
	}
	method generarPowerUpsEnJuego() {
		powerUpsEncendidos = true
		game.onTick(7000, "PocionesMana",{ => game.addVisual(new PocionMana())})
		game.onTick(8000, "Monedas", { => game.addVisual(new Monedas())})
		game.onTick(3000, "VesselPocion", { => game.addVisual(new VesselMana())})
		game.onTick(6000, "PocionSalud", { => game.addVisual(new PocionSalud())})
	}

	method aparecerSalida() {
		if (self.condicionDeNivel() and !game.hasVisual(puertaSalida)) {
			game.addVisual(puertaSalida)	
		}
	}
	
	method condicionDeNivel() {return self.todosEnemigosMuertos() and protagonista.energia() > 0 and protagonista.salud() > 0}
	
	method verificaFinDeNivel() {
		if (protagonista.energia() <= 0 or protagonista.salud() <= 0) {
			self.perder()
		} else if (protagonista.position() == puertaSalida.position() and game.hasVisual(puertaSalida)) {
			self.ganar()
		}
	}
	
	method todosEnemigosMuertos() = enemigosEnNivel.all({e => e.salud() <= 0})
	
	method activarEnemigos() {
		game.onTick(2800, "activarEnemigos", {game.allVisuals().filter{v => v.esEnemigo()}.forEach{e => e.acercarseA(protagonista)}})
	}
	
	method detenerTodosLosEventos() {
		game.removeTickEvent("Monedas")
		game.removeTickEvent("VesselPocion")
		game.removeTickEvent("PocionMana")
		game.removeTickEvent("PocionSalud")
		game.removeTickEvent("cantidadPowerUps")
		game.removeTickEvent("activarEnemigos")
	}
	
	method perder() {
		game.clear()
		
		try {
			self.detenerGeneracionDePowerUps()
		} catch e {
		}
				
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		game.addVisual(protagonista)
		
		game.schedule(3500, {game.clear()})
		
		game.addVisual(new Fondo(image = "Pantalla_GameOver_nivel2.png" ))
		
		soundtrack.stop()
	}
	
	method ganar() {
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		try {
			self.detenerGeneracionDePowerUps()
		} catch e {
		}
		soundtrack.stop()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
			// después de un ratito ...
		game.schedule(2500, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "ganamos.png"))
				// después de un ratito ...
			game.schedule(3000, { // fin del juego
			game.stop()})
		})
	}

}

