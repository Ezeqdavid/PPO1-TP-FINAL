import wollok.game.*
import direcciones.*
import nivel1.*
import elementos.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición
class Protagonista {

	var property position = game.at(0, 0)
	const property image = "knight_f_idle_anim_f0.png"
	var property energia = 30
	var property salud = 30
	var property dinero = 0
	var direccion = arriba
	var property fragmentos = []

	method gastarEnergia() {
		energia -= 1
		self.verificarContinuidad()
	}
	
	method verificarContinuidad() {
		if (energia <= 0 or salud <= 0) {
			nivelBloques.perder()
		}
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
		const newPosition = direccion.siguiente(position)
		if (newPosition.allElements().all({e => e.esMovible()})) {
			position = newPosition
		}
	}

	method retroceder() {
		position = direccion.opuesto().siguiente(position)
	}

	method accionar(elemento) {
		elemento.reaccionar(self)
	// self.retroceder()
	}
	
	method direccion() = direccion

	method recibirDanio(enemigo) {
		if (enemigo == "Slime") {
			self.salud(self.salud() - 5)
		} else if (enemigo == "Goblin") {
			self.salud(self.salud() - 10)
		} else if (enemigo == "Orco") {
			self.salud(self.salud() - 15)
		}
	}
	
	method informarEstado() {
		return "Energia : " + self.energia().stringValue() + " Salud es: " 
				+ self.salud().stringValue() + " Dinero es: " + self.dinero().stringValue() 
				+ " Fragmentos : " + self.fragmentos().size().stringValue()
	}
	
	method recogerFragmento(fragmento) {
		fragmentos.add(fragmento)
	}
	
	method interactuar() {
		const objetos = []
		objetos.addAll(game.getObjectsIn(position.left(1)))
		objetos.addAll(game.getObjectsIn(position.right(1)))
		objetos.addAll(game.getObjectsIn(position.up(1)))
		objetos.addAll(game.getObjectsIn(position.down(1)))
		objetos.forEach({o => o.reaccionar(self)})
	}
}

