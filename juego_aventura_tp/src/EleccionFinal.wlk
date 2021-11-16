import wollok.game.*
import personajes.*
import utilidades.*
import elementos.*
import nivel3.*


object pantallaEleccion{
	
	method configurate(){
		
		game.addVisual(new Fondo(image="Pantalla-DecisionFinal.png"))
		
		keyboard.b().onPressDo({nivelConEnemigos.configurate()})
		keyboard.t().onPressDo({self.terminar()})
	}
		
	method terminar() {
		game.clear()
		game.addVisual(new Fondo(image = "fondoCompleto.png"))
		game.schedule(2500, { game.clear()
			game.addVisual(new Fondo(image = "ganamos.png"))
			game.schedule(3000, {game.stop()})
		})
	}

}
