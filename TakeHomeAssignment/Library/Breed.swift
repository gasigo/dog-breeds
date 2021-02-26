import Foundation

struct Breed: Codable, Equatable {
	enum CodingKeys: String, CodingKey {
		case name
		case temperament
		case lifespan = "life_span"
		case group = "breed_group"
		case imageURL = "reference_image_id"
	}

	let name: String
	let lifespan: String
	let temperament: String?
	let group: String?
	let imageURL: String?

	init(name: String, lifespan: String, temperament: String?, group: String?, imageURL: String?) {
		self.name = name
		self.lifespan = lifespan
		self.temperament = temperament
		self.group = group
		self.imageURL = imageURL
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.temperament = try? container.decode(String.self, forKey: .temperament)
		self.lifespan = try container.decode(String.self, forKey: .lifespan)
		self.group = try? container.decode(String.self, forKey: .group)

		if let imageID = try? container.decode(String.self, forKey: .imageURL) {
			self.imageURL = "https://cdn2.thedogapi.com/images/\(imageID)_1280.jpg"
		} else {
			self.imageURL = nil
		}
	}
}
