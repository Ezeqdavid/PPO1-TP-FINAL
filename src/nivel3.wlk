import wollok.game.*
import personajes.*
import utilidades.*
import elementos.*
import enemigos.*
import nivel2.*
import nivel1.*

object nivelConEnemigos {
	
	const instructivoNivel3 = new Fondo(image = "InstructivoNivel3.png")
	
    //se crea el prota
	const protaNivel3 = new Protagonista(position= game.at(0,1), salud = 3000 ,energia = 500, image = "prota_nivel3.png")
	 
	//se crean los enemigos
	
	var property monedasEnNivel = 0
  	var property powerUpsEnNivel = 0
  	var property enemigosEnNivel = []

	const property soundtrack = new Sound(file = "chopin_preludio4.mp3")
	
	//se crean los indicadores
	const energia = new IndicadorEnergia()
	const salud = new IndicadorSalud()

	method configurate() {
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
		game.addVisual(protaNivel3)
		
		game.addVisual(instructivoNivel3)
		
		// teclado
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.q().onPressDo({game.say(self, self.enemigosEnNivel().size().toString())})
		
		keyboard.space().onPressDo({game.say(protaNivel3, protaNivel3.informarEstado())})
		
		keyboard.f().onPressDo({protaNivel3.interactuar()})
		
		keyboard.h().onPressDo({protaNivel3.lanzarEspada()})
		
		keyboard.l().onPressDo({self.desactivarEnemigos()})

        //otros
		keyboard.g().onPressDo({self.ganar()})
		
		keyboard.any().onPressDo({self.aparecerSalida() self.verificaFinDeNivel()})
		
		keyboard.enter().onPressDo({game.removeVisual(instructivoNivel3) self.configurarMovimientoTeclado() self.activarEnemigos() self.corroborarCantidadPowerUps() self.reproducir() })
		
		//colisiones.
	   game.onCollideDo(protaNivel3, {o => protaNivel3.accionar(o)})
	    
	}
	
	method configurarMovimientoTeclado() {
		keyboard.up().onPressDo({ protaNivel3.moverArriba()
			protaNivel3.gastarEnergia() energia.visualizar(protaNivel3) salud.visualizar(protaNivel3) 
		})
		keyboard.down().onPressDo({ protaNivel3.moverAbajo()
			protaNivel3.gastarEnergia() energia.visualizar(protaNivel3) salud.visualizar(protaNivel3) 
		})
		keyboard.right().onPressDo({ protaNivel3.moverDerecha()
			protaNivel3.gastarEnergia() energia.visualizar(protaNivel3) salud.visualizar(protaNivel3) 
		})
		keyboard.left().onPressDo({ protaNivel3.moverIzquierda()
			protaNivel3.gastarEnergia() energia.visualizar(protaNivel3) salud.visualizar(protaNivel3) 
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
		if (self.powerUpsEnNivel() > 15) {
			self.detenerGeneracionDePowerUps() 
		} else {
			self.generarPowerUpsEnJuego()
		}
	}
	
	method detenerGeneracionDePowerUps() {
		game.removeTickEvent("Monedas")
		game.removeTickEvent("VesselPocion")
		game.removeTickEvent("PocionMana")
	}
	method generarPowerUpsEnJuego() {
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
	
	method condicionDeNivel() {return self.todosEnemigosMuertos() and protaNivel3.energia() > 0 and protaNivel3.salud() > 0}
	
	method verificaFinDeNivel() {
		if (protaNivel3.energia() <= 0 or protaNivel3.salud() <= 0) {
			self.perder()
		} else if (protaNivel3.position() == puertaSalida.position() and game.hasVisual(puertaSalida)) {
			self.ganar()
		}
	}
	
	method todosEnemigosMuertos() = enemigosEnNivel.all({e => e.salud() <= 0})
	
	method activarEnemigos() {
		game.onTick(2800, "activarEnemigos", {game.allVisuals().filter{v => v.esEnemigo()}.forEach{e => e.acercarseA(protaNivel3)}})
	}
	
	method desactivarEnemigos(){
		game.removeTickEvent("activarEnemigos")
	}

	
	method perder() {
		game.clear()
				
		game.clear()
		
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		game.addVisual(protaNivel3)
		
		game.schedule(3500, {game.clear()})
		
		game.addVisual(new Fondo(image = "Pantalla_GameOver_nivel2.png" ))
		
		soundtrack.stop()
	}
	
	method ganar() {
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
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

