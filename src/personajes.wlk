import wollok.game.*
import direcciones.*
import nivel1.*
import elementos.*
import nivel2.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición
class Protagonista {

	var property position = game.at(0, 1)
	const property image = "knight_f_idle_anim_f0.png"
	var property energia = 100
	var property salud = 200
	var property dinero = 0
	var property direccion = arriba
	var property fragmentos = []

	method gastarEnergia() {
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
		if (!(position.y() == game.height() - 1)) self.avanzar() else self.position(new Position(x = self.position().x(), y = 1))
	}

	method moverAbajo() {
		direccion = abajo
		if (!(position.y() == 1)) self.avanzar() else self.position(new Position(x = self.position().x(), y = game.height() - 1))
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

	method accionar(cosa) {
		if(cosa.esEnemigo()) {
			cosa.daniar(self)
		} else {
			cosa.reaccionar(self)
		}
	}
	

	method lanzarEspada(){
		const espada = new Espada(position = direccion.siguiente(position), direccion = self.direccion())
		var celdas = 0
		
		game.onTick(400, "lanzamientoEspada", {
			espada.avanzar(self)
			celdas += 1
			if (celdas == 3) {
				game.removeVisual(espada)
			}
			
		})
		
		game.addVisual(espada)
		
		game.onCollideDo(espada, {
			e => espada.daniar(e)
			game.removeVisual(espada)
		})
	}

	method recibirDanio() {
		const sound = new Sound(file = "hit.mp3")
		sound.volume(0.7)
		sound.play()
		self.retroceder()
		self.salud(self.salud() - 20)
	}
	
	method informarEstado() {
		return "Energia : " + self.energia().stringValue() + " Salud es: " 
				+ self.salud().stringValue() + " Dinero es: " + self.dinero().stringValue() 
				+ " Fragmentos : " + self.fragmentos().size().stringValue() + " Monedas Faltantes : "
				+ nivelMonedas.monedasEnNivel().stringValue()
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
	
	method esMovible() = false
	method esEnemigo() = false
	method hayAlgo() = true
	
	method dejarFragmentos(){
		fragmentos.clear()
	}
}

