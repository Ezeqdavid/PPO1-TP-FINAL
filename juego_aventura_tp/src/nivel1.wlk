import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {
    //se crea el prota
	const prota1 = new Protagonista()
    // se crean los fragmentos
	const fragmento1 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image = "Fragment_1_golden_sword.png")
	const fragmento2 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image = "Fragment_2_golden_sword.png")
	const fragmento3 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image ="Broken_golden_sword.png" )
	const fragmento4 = new FragmentoEspada(position = utilidadesParaJuego.posicionArbitraria(), image = "Gem_golden_sword.png")
	
	//se crean los indicadores
	const energiaIndicador = new IndicadorEnergia(position = game.at(1,0))
	const salud = new IndicadorSalud(position = game.at(0,0))
	

	method configurate() {
	
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		

		//forja
		game.addVisual(forja)
		
		//celdas	
		game.addVisual(new CeldaQuitaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new CeldaAgregaEnergia(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new CeldaTeletransportadora(position = utilidadesParaJuego.posicionArbitraria()))
		
		
		//pociones
		game.addVisual(new VesselMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		game.addVisual(new PocionMana(position = utilidadesParaJuego.posicionArbitraria()))
		
		//moneda
		game.addVisual(new Monedas(position = utilidadesParaJuego.posicionArbitraria())) 
		

		
		//escalera y cofres
		game.addVisual(escalera)
		
	    game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitrariaParaCofres()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitrariaParaCofres()))
		game.addVisual(new Cofre(position = utilidadesParaJuego.posicionArbitrariaParaCofres()))
		
		// fragmentos de espada
		game.addVisual(fragmento1)
		game.addVisual(fragmento2)
		game.addVisual(fragmento3)
		game.addVisual(fragmento4)
		
		//indicadores
		game.addVisual(energiaIndicador)
		game.addVisual(salud)

		
		//prota
		game.addVisual(prota1)
			
				
		game.whenCollideDo(prota1, {e => prota1.accionar(e)})

		//game.onCollideDo(prota1, {o => prota1.accionar(o)})
		
		game.onCollideDo(escalera, {cofre => escalera.reaccionar(cofre)})

			//teclado
			// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({ self.terminar()})
		
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})

		keyboard.space().onPressDo({game.say(prota1, prota1.informarEstado())})

		keyboard.x().onPressDo({prota1.interactuar()})


			
		// teclado movimiento:
		keyboard.up().onPressDo({ prota1.moverArriba()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		keyboard.down().onPressDo({ prota1.moverAbajo()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		keyboard.right().onPressDo({ prota1.moverDerecha()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		keyboard.left().onPressDo({ prota1.moverIzquierda()
			prota1.gastarEnergia()
			energiaIndicador.visualizar(prota1)
		})
		
	}

	method perder() {
		game.clear()
		
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		
		game.addVisual(prota1)
		
		game.schedule(3500, {game.clear()})
		
		game.addVisual(new Fondo(image = "Pantalla-GameOver.png" ))
	}
	
	method verificaFinDeNivel() {
		if (prota1.energia() <= 0 or prota1.salud() <= 0){
			self.perder()
		}
		else if (forja.objetivoLogrado() and escalera.objetivoLogrado()) {
			self.terminar()
		}
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

