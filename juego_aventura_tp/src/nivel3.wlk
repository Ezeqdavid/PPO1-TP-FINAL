import wollok.game.*
import fondo.*
import personajes.*
import utilidades.*
import elementos.*
import enemigos.*
import nivel2.*

object nivelConEnemigos {
	
    //se crea el prota
	const personajeSimple = new Protagonista()
	 
	//se crean los enemigos
	const orco1 = new Orco(position = utilidadesParaJuego.posicionArbitraria(), image = "ogre_idle_anim_f0.png")
	const orco2 = new Orco(position = utilidadesParaJuego.posicionArbitraria(), image = "ogre_idle_anim_f0.png")
	const goblin1 = new Goblin(position = utilidadesParaJuego.posicionArbitraria(), image = "goblin_idle_anim_f0.png" )
	
	var property monedasEnNivel = 0
	
	const property soundtrack = new Sound(file = "chopin_preludio4.mp3")
	
	//se crean los indicadores
	const energia = new IndicadorEnergia(position = game.at(1,0))
	const salud = new IndicadorSalud(position = game.at(0,0))

	method configurate() {
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		

		//se crean y se agregan las celdas
		game.addVisual(new CeldaQuitaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new CeldaAgregaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new CeldaTeletransportadora(position = utilidadesParaJuego.posicionArbitraria()))
		

		//se crean y se agregan las pociones de mana 
		game.addVisual(new VesselMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		
		//se crean y se agregan las pociones de salud
		game.addVisual(new PocionSalud(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionSalud(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new VesselSalud(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new VesselSalud(position = utilidadesParaJuego.posicionArbitraria()))
		
		//se crean y se agregan monedas Sanguinarias
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))

	
		// se agregan los indicadores
		game.addVisual(energia)
		game.addVisual(salud)
		
		//se agregan los enemigos
		game.addVisual(orco1)
		game.addVisual(orco2)
		game.addVisual(goblin1)
		
        //se agrega el prota 
		game.addVisual(personajeSimple)
		
		// teclado
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.space().onPressDo({game.say(personajeSimple, personajeSimple.informarEstado())})
		
		keyboard.x().onPressDo({personajeSimple.interactuar()})
			
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
			

		keyboard.g().onPressDo({ self.ganar()})
		
		keyboard.any().onPressDo({self.reproducir()self.aparecerSalida() self.verificaFinDeNivel()})

		
		//colisiones.
	    game.onCollideDo(personajeSimple, {o => personajeSimple.accionar(o)})
	    game.whenCollideDo(orco1, {p => orco1.daniar(personajeSimple)})
	    
	    //evento enemigos
	    
	    game.onTick(3500, "movimientoEnemigos", {
	       orco1.acercarseA(personajeSimple)
	       //orco2.acercarseA(personajeSimple)
	       goblin1.acercarseA(personajeSimple)
	    })
	}
	
	method reproducir() {
		if (!self.soundtrack().played()) {
			self.soundtrack().shouldLoop(true)
			self.soundtrack().volume(0.4)
			self.soundtrack().play()
		}
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
			game.addVisual(new Fondo(image = "ganamos.png"))
				// después de un ratito ...
			game.schedule(3000, { // fin del juego
			game.stop()})
		})
	}

}

