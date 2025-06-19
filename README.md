# sk_ciminfo

**Information Marker System with Optional Image Support for QBCore - FiveM**

## 📌 Description
`sk_ciminfo` is a FiveM script built for the QBCore framework that allows players to place in-world information markers with custom messages and optional image URLs. Perfect for creating RP-style signs, announcements, or instructions directly within the game environment.

## ⚙️ Features
- Place message markers anywhere in the world using the `/cim` command.
- Optionally attach an image using a direct URL.
- Remove the nearest marker using `/delcim`.
- Supports multiple markers simultaneously.
- Automatically reloads markers when a player joins the server.
- NUI image viewer with `K` key support for attached images.
- Chat suggestions for available commands.

## 🧾 Commands
`/cim <message> [image_url]`  Places a marker with a message and optional image URL 
`/delcim`             Deletes the closest marker within 1 meter       

- Markers become visible within 20 meters.
- Message appears when within 0.5 meters.
- If an image is attached, press **K** to view it in a pop-up window.

## 📂 Installation
1. Download and place the `sk_ciminfo` folder in your `resources` directory (preferably under `resources/[local]`).
2. Add the following line to your `server.cfg`: ensure sk_ciminfo
3. Ensure you are using the **QBCore Framework**.

## 📁 File Structure
- `client.lua` – Handles marker rendering and NUI interactions on the client side.
- `server.lua` – Processes commands and manages marker data server-side.
- `html/index.html` – NUI interface for image viewing (make sure to include this file under a folder named `html`).

## 🧰 Dependencies
- [QBCore Framework](https://github.com/qbcore-framework)
- A server running **fx_version 'cerulean'**

## 🧑‍💻 Author
**SK Official**
For support or suggestions, feel free to contact the developer via Discord or GitHub.

## 📜 License
This project is licensed under the Apache License 2.0 — you are free to use, modify, and distribute the code, as long as proper credit is given and the license terms are followed.
See the LICENSE file for details.
