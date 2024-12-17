// Initialize Rails UJS, ActiveStorage, and ActionCable channels
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage"; // Correct import for ActiveStorage
import "./channels/index.js"; // Import your ActionCable channels

// Import Alpine.js and stylesheets
//import "alpinejs";
import "./stylesheets/application.css";


// Import feature-specific JavaScript files
import "./features/change_view_based_on_state.js";
import "./features/show.js";
import "./features/user_badge.js";
import "./features/validations.js";

// Configure Turbo
import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = false;

// Uncomment to use static images
// Import all images from ../images directory
// const images = import.meta.glob("../images/**");

// Initialize Rails UJS and ActiveStorage
Rails.start();
ActiveStorage.start();
