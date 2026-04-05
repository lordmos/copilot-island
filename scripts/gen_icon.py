import cairosvg, os, json

os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

sizes = [(16,1),(16,2),(32,1),(32,2),(128,1),(128,2),(256,1),(256,2),(512,1),(512,2)]
path1 = "M7.998 15.035c-4.562 0-7.873-2.914-7.998-3.749V9.338c.085-.628.677-1.686 1.588-2.065.013-.07.024-.143.036-.218.029-.183.06-.384.126-.612-.201-.508-.254-1.084-.254-1.656 0-.87.128-1.769.693-2.484.579-.733 1.494-1.124 2.724-1.261 1.206-.134 2.262.034 2.944.765.05.053.096.108.139.165.044-.057.094-.112.143-.165.682-.731 1.738-.899 2.944-.765 1.23.137 2.145.528 2.724 1.261.566.715.693 1.614.693 2.484 0 .572-.053 1.148-.254 1.656.066.228.098.429.126.612.012.076.024.148.037.218.924.385 1.522 1.471 1.591 2.095v1.872c0 .766-3.351 3.795-8.002 3.795Zm0-1.485c2.28 0 4.584-1.11 5.002-1.433V7.862l-.023-.116c-.49.21-1.075.291-1.727.291-1.146 0-2.059-.327-2.71-.991A3.222 3.222 0 0 1 8 6.303a3.24 3.24 0 0 1-.544.743c-.65.664-1.563.991-2.71.991-.652 0-1.236-.081-1.727-.291l-.023.116v4.255c.419.323 2.722 1.433 5.002 1.433ZM6.762 2.83c-.193-.206-.637-.413-1.682-.297-1.019.113-1.479.404-1.713.7-.247.312-.369.789-.369 1.554 0 .793.129 1.171.308 1.371.162.181.519.379 1.442.379.853 0 1.339-.235 1.638-.54.315-.322.527-.827.617-1.553.117-.935-.037-1.395-.241-1.614Zm4.155-.297c-1.044-.116-1.488.091-1.681.297-.204.219-.359.679-.242 1.614.091.726.303 1.231.618 1.553.299.305.784.54 1.638.54.922 0 1.28-.198 1.442-.379.179-.2.308-.578.308-1.371 0-.765-.123-1.242-.37-1.554-.233-.296-.693-.587-1.713-.7Z"
path2 = "M6.25 9.037a.75.75 0 0 1 .75.75v1.501a.75.75 0 0 1-1.5 0V9.787a.75.75 0 0 1 .75-.75Zm4.25.75v1.501a.75.75 0 0 1-1.5 0V9.787a.75.75 0 0 1 1.5 0Z"

# Design: MacBook screen with notch cutout + Copilot logo on screen
r = 230          # squircle background corner radius
sw, sh = 744, 530  # screen width, height
sx, sy = 140, 215  # screen top-left
srx = 24         # screen corner radius
nw, nh = 200, 44 # notch pill width, height
nrx = nh // 2    # = 22 (full pill)
nx = 512 - nw // 2   # = 412 (notch left)
ny = sy - nh // 2    # = 193 (notch top, centered on screen top edge)
cam_cy = ny + nh // 2  # = 215 (notch center = screen top edge)
# Logo centered on usable screen area (below notch bottom at y=237)
notch_bottom = ny + nh    # = 237
screen_bottom = sy + sh   # = 745
logo_center_y = (notch_bottom + screen_bottom) / 2  # = 491
logo_size = 400
logo_scale = logo_size / 16   # = 25
logo_x = 512 - logo_size / 2  # = 312
logo_y = logo_center_y - logo_size / 2  # = 291

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#7BC4A0"/>
      <stop offset="100%" stop-color="#3D8A6C"/>
    </linearGradient>
    <linearGradient id="screenbg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#1A2E24"/>
      <stop offset="100%" stop-color="#0C1A12"/>
    </linearGradient>
    <!-- Mask: show screen everywhere except the notch cutout -->
    <mask id="screenmask">
      <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="white"/>
      <rect x="{nx}" y="{ny}" width="{nw}" height="{nh}" rx="{nrx}" fill="black"/>
    </mask>
  </defs>

  <!-- Sage green gradient squircle background -->
  <rect width="1024" height="1024" rx="{r}" ry="{r}" fill="url(#bg)"/>

  <!-- Screen body with notch cutout (green background shows through the notch) -->
  <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="url(#screenbg)" mask="url(#screenmask)"/>

  <!-- Screen border (subtle green-tinted ring, also masked at notch) -->
  <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="none"
        stroke="rgba(123,196,160,0.28)" stroke-width="2" mask="url(#screenmask)"/>

  <!-- Notch outline ring for visual definition -->
  <rect x="{nx-1}" y="{ny-1}" width="{nw+2}" height="{nh+2}" rx="{nrx+1}" fill="none"
        stroke="rgba(255,255,255,0.14)" stroke-width="1.5"/>

  <!-- Camera dot in notch center -->
  <circle cx="512" cy="{cam_cy}" r="6" fill="#0C1A12" opacity="0.7"/>
  <circle cx="512" cy="{cam_cy}" r="2.5" fill="#1A3D2A"/>

  <!-- Copilot logo centered on screen (white, 90% opacity) -->
  <g transform="translate({logo_x:.1f},{logo_y:.1f}) scale({logo_scale:.3f})" fill="white" opacity="0.9">
    <path d="{path1}"/>
    <path d="{path2}"/>
  </g>
</svg>'''
icon_dir = "CopilotIsland/Assets.xcassets/AppIcon.appiconset"
with open(f"{icon_dir}/AppIcon_source.svg","w") as f: f.write(svg)
entries = []
for (sp,sx) in sizes:
    px = sp*sx; fn = f"AppIcon_{sp}x{sp}@{sx}x.png"
    cairosvg.svg2png(url=f"{icon_dir}/AppIcon_source.svg", write_to=f"{icon_dir}/{fn}", output_width=px, output_height=px)
    entries.append((sp,sx,fn)); print(f"  {fn}")
images=[{"filename":fn,"idiom":"mac","scale":f"{sx}x","size":f"{sp}x{sp}"} for (sp,sx,fn) in entries]
with open(f"{icon_dir}/Contents.json","w") as f: json.dump({"images":images,"info":{"author":"xcode","version":1}},f,indent=2)
print("Done!")
