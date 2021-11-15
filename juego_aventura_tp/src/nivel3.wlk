import wollok.game.*
import fondo.*
import personajes.*
import utilidades.*
import elementos.*
import enemigos.*
import nivel2.*

object nivelConEnemigos {
	
    //se crea el prota
	const protaNivel3 = new Protagonista(salud = 200, image = "prota_nivel3.png")
	 
	//se crean los enemigos
	const orco4 = new Orco()
	const orco5 = new Orco()
	const orco6 = new Orco()
	
	var property monedasEnNivel = 0
  
	const orco1 = new Orco(position = utilidadesParaJuego.posicionArbitraria(), image = "ogre_idle_anim_f0.png", salud = 200)
	//const orco2 = new Orco(position = utilidadesParaJuego.posicionArbitraria(), image = "ogre_idle_anim_f0.png", salud=)
	const goblin1 = new Goblin(position = utilidadesParaJuego.posicionArbitraria(), image = "goblin_idle_anim_f0.png", salud = 60 )
	
	var property enemigosEnNivel = []

	
	const property soundtrack = new Sound(file = "chopin_preludio4.mp3")
	
	//se crean los indicadores
	const energia = new IndicadorEnergia()
	const salud = new IndicadorSalud()

	method configurate() {
		game.addVisual(new Fondo())
		

		//se crean y se agregan las celdas
		game.addVisual(new CeldaQuitaEnergia())
		game.addVisual(new CeldaAgregaEnergia())
		game.addVisual(new CeldaTeletransportadora())
		

		//se crean y se agregan las pociones de mana 
		game.addVisual(new VesselMana())
		game.addVisual(new PocionMana())
		game.addVisual(new PocionMana())
		
		//se crean y se agregan las pociones de salud
		game.addVisual(new PocionSalud())
		game.addVisual(new PocionSalud())
		game.addVisual(new VesselSalud())
		game.addVisual(new VesselSalud())
		
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
		
		//se agregan los enemigos
		game.addVisual(orco1)

		game.addVisual(orco4)
		game.addVisual(orco5)
		//game.addVisual(orco2)
		game.addVisual(goblin1)
		
	   self.enemigosEnNivel().addAll([orco1,goblin1])
		
        //se agrega el prota 
		game.addVisual(protaNivel3)
		
		// teclado
		keyboard.i().onPressDo({game.allVisuals().forEach({o => game.say(o, o.toString())})})
		
		keyboard.space().onPressDo({game.say(protaNivel3, protaNivel3.informarEstado())})
		
		keyboard.x().onPressDo({protaNivel3.interactuar()})
		
		keyboard.h().onPressDo({protaNivel3.lanzarEspada()})
			
		//movimiento
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
			
        //otros
		keyboard.g().onPressDo({ self.ganar()})
		
		keyboard.any().onPressDo({self.reproducir() self.aparecerSalida() self.verificaFinDeNivel()})

		
		//colisiones.
	    game.onCollideDo(protaNivel3, {o => protaNivel3.accionar(o)})
	    game.whenCollideDo(orco1, {p => orco1.daniar(protaNivel3)})
	    
	    //evento enemigos
	    
	    game.onTick(2800, "movimientoOrco", {orco1.acercarseA(protaNivel3)})
	    game.onTick(2800, "movimientoGoblin", {goblin1.acercarseA(protaNivel3)})
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
	
	method condicionDeNivel() {return self.todosEnemigosMuertos() and protaNivel3.energia() > 0}
	
	method verificaFinDeNivel() {
		if (protaNivel3.energia() <= 0 or protaNivel3.salud() <= 0) {
			self.perder()
		} else if (protaNivel3.position() == puertaSalida.position() and game.hasVisual(puertaSalida)) {
			self.ganar()
		}
	}
	
	method todosEnemigosMuertos() = enemigosEnNivel.all({e => e.salud() == 0})

	
	method perder() {
		game.clear()
				
		//game.clear()
		
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

