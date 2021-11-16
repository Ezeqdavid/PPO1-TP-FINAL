import wollok.game.*
import personajes.*
import utilidades.*
import elementos.*
import nivel3.*
import EleccionFinal.*

object nivelMonedas {
	
    //se crea el prota
	const personajeSimple = new Protagonista(salud = 30)
	
	var property monedasEnNivel = 0
	
	const property soundtrack = new Sound(file = "chopin_preludio4.mp3")
	const instructivoNivel2 = new Fondo(image = "InstructivoNivel2.png")
	
	//se crean los indicadores
	const energia = new IndicadorEnergia(position = game.at(1,0))
	const salud = new IndicadorSalud(position = game.at(0,0))

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		
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
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
		game.addVisual(new MonedaSanguinaria())
	
		// se agregan los indicadores
		game.addVisual(energia)
		game.addVisual(salud)
		
        //se agrega el prota 
		game.addVisual(personajeSimple)
		
		game.addVisual(instructivoNivel2)
		// teclado
		
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.space().onPressDo({game.say(personajeSimple, personajeSimple.informarEstado())})
		
		keyboard.f().onPressDo({personajeSimple.interactuar()})
		
        // otros 
        
        keyboard.enter().onPressDo({self.reproducir() self.generarPowerUpsEnJuego() self.configurarMovimientoTeclado() game.removeVisual(instructivoNivel2)})
		keyboard.g().onPressDo({ self.ganar()})
		
		keyboard.any().onPressDo({self.aparecerSalida() self.verificaFinDeNivel()})
		
		//colisiones.
	    game.onCollideDo(personajeSimple, {o => personajeSimple.accionar(o)})
	}
	
	method reproducir() {
		if (!self.soundtrack().played()) {
			self.soundtrack().shouldLoop(true)
			self.soundtrack().volume(0.4)
			self.soundtrack().play()
		}
	}
	
	method configurarMovimientoTeclado() {
		keyboard.up().onPressDo({ personajeSimple.moverArriba()
			personajeSimple.gastarEnergia() energia.visualizar(personajeSimple) salud.visualizar(personajeSimple) 
		})
		keyboard.down().onPressDo({ personajeSimple.moverAbajo()
			personajeSimple.gastarEnergia() energia.visualizar(personajeSimple) salud.visualizar(personajeSimple) 
		})
		keyboard.right().onPressDo({ personajeSimple.moverDerecha()
			personajeSimple.gastarEnergia() energia.visualizar(personajeSimple) salud.visualizar(personajeSimple) 
		})
		keyboard.left().onPressDo({ personajeSimple.moverIzquierda()
			personajeSimple.gastarEnergia() energia.visualizar(personajeSimple) salud.visualizar(personajeSimple) 
		})
	}
	
	method generarPowerUpsEnJuego() {
		game.onTick(7270, "PocionMana",{ => game.addVisual(new PocionMana())})
		game.onTick(5350, "Monedas", { => game.addVisual(new Monedas())})
		game.onTick(3128, "VesselPocion", { => game.addVisual(new VesselMana())})
		game.onTick(4275, "VesselSalud", { => game.addVisual(new VesselSalud())})
		game.onTick(5700, "PocionSalud", { => game.addVisual(new PocionSalud())})
	}
	
	method aparecerSalida() {
		if (self.condicionDeNivel() and !game.hasVisual(puertaSalida)) {
			game.addVisual(puertaSalida)	
		}
	}
	
	method condicionDeNivel() {return self.monedasEnNivel() == 0 and personajeSimple.energia() > 0}
	
	method verificaFinDeNivel() {
		if (personajeSimple.energia() <= 0 or personajeSimple.salud() <= 0) {
			self.perder()
		} else if (personajeSimple.position() == puertaSalida.position() and game.hasVisual(puertaSalida)) {
			const sound = new Sound(file = "logro.mp3")
			sound.volume(0.7)
			sound.play()
			self.ganar()
		}
	}
	
	method perder() {
		game.clear()
				
		//game.clear()
		
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		game.addVisual(personajeSimple)
		
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
			game.addVisual(new Fondo(image = "finNivel2.png"))
				// después de un ratito ...
			game.schedule(3000, { // fin del juego
			pantallaEleccion.configurate()})
		})
	}

}

