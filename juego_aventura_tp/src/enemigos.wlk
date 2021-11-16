import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
import nivel3.*

class Enemigo {
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property salud
	var property image

	method initialize() {
		nivelConEnemigos.enemigosEnNivel().add(self)
	}
	
	method movimiento(personaje) {
		game.schedule(2800, { => self.acercarseA(personaje)})
	}
	
	method hayAlgo() = true
	method esEnemigo() = true	
	method esMovible() = true
	
	method acercarseA(personaje) {
		if (salud > 0) {
			const otroPosicion = personaje.position()
			var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
			var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
			newX = newX.max(0).min(game.width() - 1)
			newY = newY.max(0).min(game.height() - 1)
			position = game.at(newX, newY)
		}
	}
	
	method recibirDanio(){
		const sound = new Sound(file = "hit2.mp3")
		sound.volume(0.5)
		sound.play()
		salud -= 40
	}

	method reaccionar(personaje){}
	method daniar(personaje){}

}

class Diablito inherits Enemigo {
	
	method initialize() {
		self.salud(20)
	}
	
	override method daniar(personaje) {
		personaje.recibirDanio()
	}

}

class Goblin inherits Enemigo {
	
	override method initialize() {
		super()
		self.salud(40)
		self.image("goblin_idle_anim_f0.png")
	}
	override method daniar(personaje) {
		personaje.recibirDanio()
	}
	
	override method recibirDanio(){
		super()
		if(salud <= 0){
			image = "goblinMuerto.png"
		}
	}
}

class Orco inherits Enemigo {
	
	override method initialize() {
		super()
		self.salud(60)
		self.image("ogre_idle_anim_f0.png")
	}
	override method daniar(personaje) {
		personaje.recibirDanio()
	}
	override method recibirDanio(){
		super()
		if(salud <= 0){
			image = "orcoMuerto.png"
		}
	}

}

