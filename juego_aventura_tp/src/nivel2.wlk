import wollok.game.*
import fondo.*
import personajes.*
import utilidades.*
import elementos.*

object nivelLlaves {
    //se crea el prota
	const personajeSimple = new Protagonista()
	
	const energiaIndicador = new IndicadorEnergia(position = game.at(1,0))

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		//se crean los cofres
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitraria()))
		

		//se crean las celdas
		game.addVisual(new CeldaQuitaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new CeldaAgregaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new CeldaTeletransportadora(position = utilidadesParaJuego.posicionArbitraria()))
		

		//se crean las pociones
		game.addVisual(new VesselMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))

		//se crean las monedas
		game.addVisual(new Monedas(position = utilidadesParaJuego.posicionArbitraria())) 
		game.addVisual(new Monedas(position = utilidadesParaJuego.posicionArbitraria())) 
		game.addVisual(new Monedas(position = utilidadesParaJuego.posicionArbitraria())) 
		
		//se crean las monedas Sanguinarias
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria()))

	
		//indicadores
		game.addVisual(energiaIndicador)
		game.addVisual(new IndicadorSalud(position = game.at(0,0)))
		
        //se agrega el prota 
		game.addVisual(personajeSimple)
		
		
		// teclado
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.space().onPressDo({game.say(personajeSimple, personajeSimple.informarEstado())})
		
		keyboard.x().onPressDo({personajeSimple.interactuar()})
			
		keyboard.up().onPressDo({ personajeSimple.moverArriba()
			personajeSimple.gastarEnergia()
		})
		keyboard.down().onPressDo({ personajeSimple.moverAbajo()
			personajeSimple.gastarEnergia()
		})
		keyboard.right().onPressDo({ personajeSimple.moverDerecha()
			personajeSimple.gastarEnergia()
		})
		keyboard.left().onPressDo({ personajeSimple.moverIzquierda()
			personajeSimple.gastarEnergia()
		})
			

		keyboard.g().onPressDo({ self.ganar()})
		
		//coliciones.
	    game.onCollideDo(personajeSimple, {o => personajeSimple.accionar(o)})
	}
	
	method aparecerSalida() {
		if (self.condicionDeNivel()) {
			game.addVisual(escaleraSalida)	
		}
	}
	
	method condicionDeNivel() {
		return !game.allVisuals().any({v => v == new Monedas(position = utilidadesParaJuego.posicionArbitraria())}) and 
			   !game.allVisuals().any({v => v == new MonedaSanguinaria(position = utilidadesParaJuego.posicionArbitraria())}) and
			   personajeSimple.energia() > 0
	}
	
	method verificaFinDeNivel() {
		if (personajeSimple.energia() <= 0 or personajeSimple.salud() <= 0) {
			self.perder()
		} else if (personajeSimple.position() == escaleraSalida.position()) {
			self.ganar()
		}
	}
	
	method perder() {
		game.clear()
	}
	
	method ganar() {
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
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

