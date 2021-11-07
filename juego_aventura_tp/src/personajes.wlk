import wollok.game.*
import direcciones.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición
class Protagonista {

	var property position = game.at(0, 0)
	const property image = "player.png"
	var property energia = 30
	var property salud = 30
	var property dinero = 0
	var direccion = arriba
	
	method gastarEnergia(){
		energia -= 1
	}
	
	method moverDerecha() {
		direccion = derecha
		if (!(position.x() == game.width() - 1)) self.avanzar() else self.position(new Position(y = self.position().y(), x = 0))
	}

	method moverIzquierda() {
		direccion = izquierda
		if (!(position.x() == 0)) self.avanzar() else self.position(new Position(y = self.position().y(), x = game.width() - 1))
	}

	method moverArriba() {
		direccion = arriba
		if (!(position.y() == game.height() - 1)) self.avanzar() else self.position(new Position(x = self.position().x(), y = 0))
	}

	method moverAbajo() {
		direccion = abajo
		if (!(position.y() == 0)) self.avanzar() else self.position(new Position(x = self.position().x(), y = game.height() - 1))
	}

	method avanzar() {
		position = direccion.siguiente(position)
	}

	method retroceder() {
		position = direccion.opuesto().siguiente(position)
	}

	method empujar(elemento) {
		elemento.mover(direccion)
	// self.retroceder()
	}

	method recibirDanio(enemigo){
		if (enemigo == "Slime"){
			self.salud(self.salud() - 5)
		} else if (enemigo == "Goblin") {
			self.salud(self.salud() - 10)
		} else if (enemigo == "Orco") {
			self.salud(self.salud() - 15)
		}
	}
}

