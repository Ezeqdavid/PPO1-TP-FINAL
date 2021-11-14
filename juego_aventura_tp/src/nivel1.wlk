import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {

	const prota1 = new Protagonista()
	const cofre1 = new Cofre(position = game.at(2,3))
	const escalera = new Escalera(position = utilidadesParaJuego.posicionArbitraria())

	method configurate() {
		
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
			// otros visuals, p.ej. bloques o llaves
			// personaje, es importante que sea el último visual que se agregue
		game.addVisual(new VesselMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new Monedas(position = utilidadesParaJuego.posicionArbitraria())) 
		game.addVisual(new CeldaQuitaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(cofre1)
		game.addVisual(escalera)
		game.addVisual(new Forja(position = utilidadesParaJuego.posicionArbitraria()))
		
		game.addVisual(prota1)
			
			
			// teclado
			// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({ self.terminar()})
		game.onCollideDo(prota1, {o => prota1.accionar(o)})
		game.onCollideDo(escalera, {cofre => escalera.reaccionar(cofre)})
			
		// teclado movimiento:
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.space().onPressDo({game.say(prota1, prota1.informarEstado())})
		
		keyboard.x().onPressDo({prota1.interactuar()})
			
		keyboard.up().onPressDo({ prota1.moverArriba()
			prota1.gastarEnergia()
		})
		keyboard.down().onPressDo({ prota1.moverAbajo()
			prota1.gastarEnergia()
		})
		keyboard.right().onPressDo({ prota1.moverDerecha()
			prota1.gastarEnergia()
		})
		keyboard.left().onPressDo({ prota1.moverIzquierda()
			prota1.gastarEnergia()
		})
	// en este no hacen falta colisiones
	}

	
	method perder() {
		game.clear()
	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
			// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		game.addVisual(prota1)
			// después de un ratito ...
		game.schedule(2500, { game.clear()
				// cambio de fondo
			game.addVisual(new Fondo(image = "finNivel1.png"))
				// después de un ratito ...
			game.schedule(3000, { // ... limpio todo de nuevo
				game.clear()
					// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}

}

