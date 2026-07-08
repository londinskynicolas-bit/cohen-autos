#!/bin/bash
set -e
echo "Actualizando site/index.html..."
cat > site/index.html << 'FILEEOF'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Cohen Autos — Autos nuevos y usados</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Work+Sans:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
<script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
<script src="https://unpkg.com/@babel/standalone@7.24.7/babel.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<style>
  :root {
    --paper:#FAF6F0; --surface:#FFFFFF; --ink:#2B2420; --rust:#8C3B2E; --rustDark:#6C2C21;
    --brass:#B8874A; --brassSoft:#E8CFA0; --whats:#22B24C; --line:#E4DCCB; --mute:#7C7266;
  }
  * { box-sizing:border-box; }
  body { margin:0; background:var(--paper); color:var(--ink); font-family:'Work Sans',system-ui,sans-serif; }

  .navbar { display:flex; align-items:center; justify-content:space-between; padding:18px 28px; border-bottom:1px solid var(--line); position:sticky; top:0; background:var(--paper); z-index:10; }
  .navbar .logo { font-family:'Fraunces',serif; font-weight:600; font-size:23px; letter-spacing:0.2px; color:var(--rustDark); text-decoration:none; }
  .navbar .logo span { color:var(--brass); }

  .hero { background:var(--rust); color:#fff; padding:48px 28px; text-align:center; }
  .hero h1 { font-family:'Fraunces',serif; font-weight:600; font-style:italic; font-size:clamp(28px,5vw,42px); margin:0 0 10px; letter-spacing:0.2px; }
  .hero p { margin:0; color:#f0ddd0; font-size:15px; }

  .catalogo { display:grid; grid-template-columns:270px 1fr; gap:24px; padding:28px; max-width:1200px; margin:0 auto; }

  .filtros { align-self:start; position:sticky; top:80px; display:flex; flex-direction:column; gap:14px; }
  .f-card { background:var(--surface); border:1px solid var(--line); border-radius:10px; padding:16px 18px; }
  .f-card-head { display:flex; align-items:center; gap:8px; margin:0 0 12px; }
  .f-dot { width:7px; height:7px; border-radius:50%; background:var(--brass); flex-shrink:0; }
  .f-card-head h3 { margin:0; font-size:12px; text-transform:uppercase; letter-spacing:0.7px; color:var(--rustDark); font-weight:700; }
  .chips { display:flex; flex-wrap:wrap; gap:6px; }
  .chip { background:var(--paper); border:1px solid var(--line); color:var(--ink); padding:6px 11px; border-radius:6px; font-size:12.5px; cursor:pointer; }
  .chip.on { background:var(--rust); border-color:var(--rust); color:#fff; font-weight:600; }
  .rd-labels { display:flex; justify-content:space-between; font-size:12px; color:var(--mute); margin-bottom:8px; font-family:'Space Mono',monospace; }
  .rd-track { position:relative; height:26px; }
  .rd-fill { position:absolute; top:11px; height:4px; background:var(--rust); border-radius:2px; }
  .rd-track::before { content:''; position:absolute; top:11px; left:0; right:0; height:4px; background:var(--line); border-radius:2px; }
  .rd-track input[type=range] { position:absolute; top:0; left:0; width:100%; height:26px; background:transparent; -webkit-appearance:none; pointer-events:none; margin:0; }
  .rd-track input[type=range]::-webkit-slider-thumb { -webkit-appearance:none; pointer-events:auto; width:15px; height:15px; border-radius:50%; background:var(--rust); border:2px solid #fff; box-shadow:0 0 0 1px var(--line); cursor:pointer; }
  .rd-track input[type=range]::-moz-range-thumb { pointer-events:auto; width:15px; height:15px; border-radius:50%; background:var(--rust); border:2px solid #fff; cursor:pointer; }
  .clear-filters { background:none; border:none; color:var(--mute); font-size:12px; text-decoration:underline; cursor:pointer; padding:0; text-align:left; }

  .grid-head { color:var(--mute); font-size:13px; margin-bottom:14px; }
  .cards { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:20px; }
  .card { background:var(--surface); border:1px solid var(--line); border-radius:10px; overflow:hidden; display:flex; flex-direction:column; box-shadow:0 1px 2px rgba(43,36,32,0.06); transition:box-shadow .15s ease; cursor:pointer; }
  .card:hover { box-shadow:0 6px 16px rgba(43,36,32,0.10); }
  .card-photo { height:170px; background-size:cover; background-position:center; position:relative; background-color:var(--line); }
  .no-photo { position:absolute; inset:0; display:flex; align-items:center; justify-content:center; color:var(--mute); font-size:13px; }
  .tag { position:absolute; top:10px; left:10px; font-size:10.5px; font-weight:700; padding:4px 9px; border-radius:4px; letter-spacing:0.6px; }
  .tag-new { background:var(--brass); color:#fff; }
  .tag-used { background:var(--ink); color:#fff; }
  .card-body { padding:14px 16px 16px; display:flex; flex-direction:column; gap:6px; }
  .card-top { display:flex; justify-content:space-between; align-items:baseline; }
  .card-top h3 { margin:0; font-family:'Fraunces',serif; font-weight:600; font-size:18px; }
  .anio { color:var(--mute); font-size:13px; font-family:'Space Mono',monospace; }
  .version { color:var(--mute); font-size:12.5px; margin-top:-4px; }
  .card-specs { display:flex; gap:6px; color:var(--mute); font-size:12.5px; flex-wrap:wrap; }
  .price-row { display:flex; align-items:center; justify-content:space-between; margin-top:6px; }
  .price-tag { position:relative; font-family:'Space Mono',monospace; font-weight:700; font-size:15.5px; background:var(--paper); border:1.5px solid var(--brass); border-radius:4px; padding:5px 12px 5px 18px; color:var(--rustDark); }
  .price-tag::before { content:''; position:absolute; left:6px; top:50%; transform:translateY(-50%); width:6px; height:6px; border-radius:50%; background:var(--paper); border:1.5px solid var(--brass); }
  .btn-whats { display:flex; align-items:center; justify-content:center; gap:7px; background:var(--whats); color:#fff; text-decoration:none; padding:9px 14px; border-radius:6px; font-weight:600; font-size:13px; }
  .btn-whats.disabled { background:var(--line); color:var(--mute); cursor:not-allowed; }
  .empty { color:var(--mute); padding:40px 0; text-align:center; }
  .footer { text-align:center; padding:24px; color:var(--mute); font-size:12px; }

  /* Detalle del auto */
  .detail-top { max-width:1200px; margin:0 auto; padding:18px 28px 0; }
  .back-link { color:var(--mute); font-size:13px; text-decoration:none; display:inline-flex; align-items:center; gap:6px; }
  .back-link:hover { color:var(--rust); }
  .detail { max-width:1200px; margin:0 auto; padding:16px 28px 60px; display:grid; grid-template-columns:1.1fr 1fr; gap:36px; }
  .detail-photos .main-photo { width:100%; aspect-ratio:4/3; background-size:cover; background-position:center; border-radius:10px; border:1px solid var(--line); cursor:zoom-in; background-color:var(--line); position:relative; }
  .detail-photos .main-photo .no-photo { position:absolute; inset:0; }
  .detail-thumbs { display:flex; gap:8px; margin-top:10px; flex-wrap:wrap; }
  .detail-thumbs button { width:64px; height:48px; border-radius:6px; border:2px solid transparent; background-size:cover; background-position:center; padding:0; cursor:pointer; }
  .detail-thumbs button.on { border-color:var(--rust); }

  .detail-info h1 { font-family:'Fraunces',serif; font-weight:600; font-size:30px; margin:0 0 2px; }
  .detail-info .sub { color:var(--mute); font-size:14px; margin:0 0 14px; }
  .detail-tag { display:inline-block; font-size:11px; font-weight:700; padding:4px 10px; border-radius:4px; letter-spacing:0.6px; margin-bottom:14px; }
  .detail-price { font-family:'Space Mono',monospace; font-weight:700; font-size:28px; color:var(--rustDark); margin:6px 0 18px; }
  .spec-table { display:grid; grid-template-columns:1fr 1fr; gap:0; border:1px solid var(--line); border-radius:10px; overflow:hidden; margin-bottom:20px; }
  .spec-item { padding:12px 16px; border-bottom:1px solid var(--line); border-right:1px solid var(--line); }
  .spec-item:nth-child(2n) { border-right:none; }
  .spec-item label { display:block; font-size:10.5px; text-transform:uppercase; letter-spacing:0.5px; color:var(--mute); margin-bottom:3px; }
  .spec-item span { font-size:14px; font-weight:600; }
  .detail-desc-title { font-size:12px; text-transform:uppercase; letter-spacing:0.7px; color:var(--rustDark); font-weight:700; margin:0 0 8px; }
  .detail-desc { font-size:14.5px; line-height:1.7; color:#4a4139; white-space:pre-wrap; margin:0 0 22px; }

  .lightbox { position:fixed; inset:0; background:rgba(20,15,12,0.92); display:flex; align-items:center; justify-content:center; z-index:100; cursor:zoom-out; padding:24px; }
  .lightbox img { max-width:100%; max-height:100%; border-radius:6px; box-shadow:0 10px 40px rgba(0,0,0,0.4); }
  .lightbox .close-x { position:absolute; top:20px; right:28px; color:#fff; font-size:32px; background:none; border:none; cursor:pointer; line-height:1; }

  @media (max-width:760px) {
    .catalogo { grid-template-columns:1fr; } .filtros { position:static; }
    .detail { grid-template-columns:1fr; gap:22px; }
  }
</style>
</head>
<body>
<div id="root"></div>
<script type="text/babel" data-presets="react">
const { useState, useEffect, useMemo } = React;

// ====== CONFIGURÁ ESTO con los datos de tu proyecto Supabase ======
const SUPABASE_URL = "https://qgjagerzvjptuzfimzbr.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnamFnZXJ6dmpwdHV6ZmltemJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0NjU1MDcsImV4cCI6MjA5OTA0MTUwN30.C0pGuw0e9UNWp3wEMKZFGjDzBQp28rysmFpVLBJelpg";
// ===================================================================

const sb = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

function fmtMoney(n) { return "US$ " + Number(n).toLocaleString("es-AR"); }
function fmtKm(n) { return Number(n).toLocaleString("es-AR") + " km"; }

const COMBUSTIBLE_LABEL = { nafta: "Nafta", diesel: "Diésel", gnc: "GNC", electrico: "Eléctrico", hibrido: "Híbrido" };
const CARROCERIA_LABEL = { sedan: "Sedán", hatchback: "Hatchback", suv: "SUV", pickup: "Pick-up", coupe: "Coupé", rural: "Rural", furgon: "Furgón", cabriolet: "Cabriolet" };

function buildWhatsappUrl(car, phone) {
  const lines = [
    "Hola! Vi tu publicación en Cohen Autos y quiero consultar por más detalles:",
    "",
    `${car.marca} ${car.modelo} ${car.version || ""} ${car.anio}`.replace(/\s+/g, " ").trim(),
    `Km: ${fmtKm(car.km)}`,
    `Transmisión: ${car.transmision === "automatico" ? "Automático" : "Manual"}`,
    `Precio: ${fmtMoney(car.precio)}`,
    "",
    "¿Seguís teniendo este auto disponible?",
  ];
  return `https://wa.me/${phone}?text=${encodeURIComponent(lines.join("\n"))}`;
}

function WhatsIcon() {
  return (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M12 2a10 10 0 0 0-8.6 15.1L2 22l5.1-1.3A10 10 0 1 0 12 2zm0 18.2a8.2 8.2 0 0 1-4.2-1.1l-.3-.2-3 .8.8-2.9-.2-.3A8.2 8.2 0 1 1 12 20.2zm4.5-6.1c-.2-.1-1.5-.7-1.7-.8-.2-.1-.4-.1-.6.1s-.7.8-.8 1c-.2.2-.3.2-.5.1a6.7 6.7 0 0 1-2-1.2 7.4 7.4 0 0 1-1.4-1.7c-.1-.2 0-.4.1-.5l.4-.4a1.6 1.6 0 0 0 .2-.4.4.4 0 0 0 0-.4c-.1-.1-.6-1.4-.8-1.9-.2-.5-.4-.4-.6-.4h-.5a1 1 0 0 0-.7.3 3 3 0 0 0-.9 2.2c0 1.3.9 2.6 1.1 2.8s1.7 2.7 4.3 3.7a5 5 0 0 0 3 .2 2.6 2.6 0 0 0 1.7-1.2 2.1 2.1 0 0 0 .1-1.2c-.1-.1-.2-.2-.4-.3z" />
    </svg>
  );
}

function RangeDual({ min, max, value, onChange, step, format }) {
  const [lo, hi] = value;
  return (
    <div className="rd">
      <div className="rd-labels"><span>{format(lo)}</span><span>{format(hi)}</span></div>
      <div className="rd-track">
        <div className="rd-fill" style={{ left: `${((lo - min) / (max - min)) * 100}%`, right: `${100 - ((hi - min) / (max - min)) * 100}%` }} />
        <input type="range" min={min} max={max} step={step} value={lo} onChange={(e) => onChange([Math.min(Number(e.target.value), hi), hi])} />
        <input type="range" min={min} max={max} step={step} value={hi} onChange={(e) => onChange([lo, Math.max(Number(e.target.value), lo)])} />
      </div>
    </div>
  );
}

function FilterCard({ title, children }) {
  return (
    <div className="f-card">
      <div className="f-card-head"><span className="f-dot" /><h3>{title}</h3></div>
      {children}
    </div>
  );
}

function CarCard({ car, phone, onOpen }) {
  const fotos = car.fotos && car.fotos.length ? car.fotos : [];
  const hasPhone = !!(phone && phone.trim());
  return (
    <div className="card" onClick={() => onOpen(car.id)}>
      <div className="card-photo" style={{ backgroundImage: fotos[0] ? `url(${fotos[0]})` : "none" }}>
        <span className={"tag " + (car.condicion === "nuevo" ? "tag-new" : "tag-used")}>{car.condicion === "nuevo" ? "0KM" : "USADO"}</span>
        {!fotos.length && <div className="no-photo">Sin foto</div>}
      </div>
      <div className="card-body">
        <div className="card-top"><h3>{car.marca} {car.modelo}</h3><span className="anio">{car.anio}</span></div>
        {car.version && <div className="version">{car.version}</div>}
        <div className="card-specs">
          <span>{fmtKm(car.km)}</span><span>·</span>
          <span>{car.transmision === "automatico" ? "Automático" : "Manual"}</span><span>·</span>
          <span>{car.color}</span>
        </div>
        <div className="price-row"><div className="price-tag">{fmtMoney(car.precio)}</div></div>
        <a
          className={"btn-whats" + (hasPhone ? "" : " disabled")}
          href={hasPhone ? buildWhatsappUrl(car, phone.trim()) : undefined}
          target="_blank" rel="noreferrer"
          title={hasPhone ? "" : "Todavía no se cargó el WhatsApp"}
          onClick={(e) => { e.stopPropagation(); if (!hasPhone) e.preventDefault(); }}
        >
          <WhatsIcon /> Consultame
        </a>
      </div>
    </div>
  );
}

function CarDetail({ car, phone, onBack }) {
  const fotos = car.fotos && car.fotos.length ? car.fotos : [];
  const [active, setActive] = useState(0);
  const [zoom, setZoom] = useState(false);
  const hasPhone = !!(phone && phone.trim());

  useEffect(() => { window.scrollTo({ top: 0 }); }, []);

  return (
    <React.Fragment>
      <div className="detail-top">
        <a className="back-link" href="#/" onClick={onBack}>← Volver al catálogo</a>
      </div>
      <div className="detail">
        <div className="detail-photos">
          <div
            className="main-photo"
            style={{ backgroundImage: fotos[active] ? `url(${fotos[active]})` : "none" }}
            onClick={() => fotos[active] && setZoom(true)}
          >
            {!fotos.length && <div className="no-photo">Sin foto</div>}
          </div>
          {fotos.length > 1 && (
            <div className="detail-thumbs">
              {fotos.map((f, i) => (
                <button key={i} className={i === active ? "on" : ""} style={{ backgroundImage: `url(${f})` }} onClick={() => setActive(i)} />
              ))}
            </div>
          )}
        </div>

        <div className="detail-info">
          <span className={"detail-tag " + (car.condicion === "nuevo" ? "tag-new" : "tag-used")} style={{ background: car.condicion === "nuevo" ? "var(--brass)" : "var(--ink)", color: "#fff" }}>
            {car.condicion === "nuevo" ? "0KM" : "USADO"}
          </span>
          <h1>{car.marca} {car.modelo}</h1>
          <p className="sub">{car.version ? car.version + " · " : ""}{car.anio}</p>
          <div className="detail-price">{fmtMoney(car.precio)}</div>

          <div className="spec-table">
            <div className="spec-item"><label>Kilómetros</label><span>{fmtKm(car.km)}</span></div>
            <div className="spec-item"><label>Transmisión</label><span>{car.transmision === "automatico" ? "Automático" : "Manual"}</span></div>
            <div className="spec-item"><label>Combustible</label><span>{COMBUSTIBLE_LABEL[car.combustible] || car.combustible || "—"}</span></div>
            <div className="spec-item"><label>Carrocería</label><span>{CARROCERIA_LABEL[car.carroceria] || car.carroceria || "—"}</span></div>
            <div className="spec-item"><label>Color</label><span>{car.color || "—"}</span></div>
            <div className="spec-item"><label>Tracción</label><span>{car.traccion === "4x4" ? "4x4 / AWD" : "4x2"}</span></div>
            <div className="spec-item"><label>Puertas</label><span>{car.puertas || "—"}</span></div>
            <div className="spec-item"><label>Motor</label><span>{car.motor || "—"}</span></div>
          </div>

          {car.descripcion && (
            <React.Fragment>
              <p className="detail-desc-title">Descripción</p>
              <p className="detail-desc">{car.descripcion}</p>
            </React.Fragment>
          )}

          <a
            className={"btn-whats" + (hasPhone ? "" : " disabled")}
            href={hasPhone ? buildWhatsappUrl(car, phone.trim()) : undefined}
            target="_blank" rel="noreferrer"
            title={hasPhone ? "" : "Todavía no se cargó el WhatsApp"}
            onClick={(e) => { if (!hasPhone) e.preventDefault(); }}
            style={{ maxWidth: 260 }}
          >
            <WhatsIcon /> Consultame por este auto
          </a>
        </div>
      </div>

      {zoom && fotos[active] && (
        <div className="lightbox" onClick={() => setZoom(false)}>
          <button className="close-x" onClick={() => setZoom(false)}>×</button>
          <img src={fotos[active]} alt="" />
        </div>
      )}
    </React.Fragment>
  );
}

function useHashRoute() {
  const [hash, setHash] = useState(window.location.hash);
  useEffect(() => {
    const f = () => setHash(window.location.hash);
    window.addEventListener("hashchange", f);
    return () => window.removeEventListener("hashchange", f);
  }, []);
  return hash;
}

function App() {
  const [cars, setCars] = useState([]);
  const [whatsapp, setWhatsapp] = useState("");
  const [loading, setLoading] = useState(true);
  const [condicion, setCondicion] = useState("todos");
  const [transmision, setTransmision] = useState("todos");
  const [km, setKm] = useState([0, 350000]);
  const [precio, setPrecio] = useState([0, 50000]);
  const hash = useHashRoute();

  useEffect(() => {
    (async () => {
      const { data: carsData } = await sb.from("cars").select("*").order("created_at", { ascending: false });
      const { data: settingsData } = await sb.from("settings").select("whatsapp").eq("id", 1).single();
      setCars(carsData || []);
      setWhatsapp((settingsData && settingsData.whatsapp) || "");
      setLoading(false);
    })();
  }, []);

  const filtrados = useMemo(() => cars.filter(c =>
    (condicion === "todos" || c.condicion === condicion) &&
    (transmision === "todos" || c.transmision === transmision) &&
    c.km >= km[0] && c.km <= km[1] &&
    c.precio >= precio[0] && c.precio <= precio[1]
  ), [cars, condicion, transmision, km, precio]);

  function clearFilters() {
    setCondicion("todos"); setTransmision("todos"); setKm([0, 350000]); setPrecio([0, 50000]);
  }

  function openCar(id) { window.location.hash = "#/auto/" + id; }

  const detailMatch = hash.match(/^#\/auto\/(.+)$/);
  const carDetail = detailMatch ? cars.find(c => String(c.id) === detailMatch[1]) : null;

  return (
    <React.Fragment>
      <div className="navbar"><a className="logo" href="#/">Cohen <span>Autos</span></a></div>

      {carDetail ? (
        <CarDetail car={carDetail} phone={whatsapp} onBack={() => {}} />
      ) : (
        <React.Fragment>
          <div className="hero">
            <h1>Encontrá tu próximo auto</h1>
            <p>Autos nuevos y usados, revisados y listos para entregar.</p>
          </div>
          <div className="catalogo">
            <aside className="filtros">
              <FilterCard title="Condición">
                <div className="chips">
                  {["todos", "nuevo", "usado"].map(v => (
                    <button key={v} className={condicion === v ? "chip on" : "chip"} onClick={() => setCondicion(v)}>
                      {v === "todos" ? "Todos" : v === "nuevo" ? "0km" : "Usado"}
                    </button>
                  ))}
                </div>
              </FilterCard>

              <FilterCard title="Transmisión">
                <div className="chips">
                  {["todos", "manual", "automatico"].map(v => (
                    <button key={v} className={transmision === v ? "chip on" : "chip"} onClick={() => setTransmision(v)}>
                      {v === "todos" ? "Todas" : v === "manual" ? "Manual" : "Automático"}
                    </button>
                  ))}
                </div>
              </FilterCard>

              <FilterCard title="Kilómetros">
                <RangeDual min={0} max={350000} step={5000} value={km} onChange={setKm} format={fmtKm} />
              </FilterCard>

              <FilterCard title="Precio">
                <RangeDual min={0} max={50000} step={500} value={precio} onChange={setPrecio} format={fmtMoney} />
              </FilterCard>

              <button className="clear-filters" onClick={clearFilters}>Limpiar todos los filtros</button>
            </aside>
            <section className="grid">
              {loading ? <div className="empty">Cargando autos...</div> : (
                <React.Fragment>
                  <div className="grid-head">{filtrados.length} {filtrados.length === 1 ? "auto encontrado" : "autos encontrados"}</div>
                  {filtrados.length === 0
                    ? <div className="empty">No hay autos que coincidan con esos filtros. Probá abrir un poco el rango.</div>
                    : <div className="cards">{filtrados.map(c => <CarCard key={c.id} car={c} phone={whatsapp} onOpen={openCar} />)}</div>}
                </React.Fragment>
              )}
            </section>
          </div>
        </React.Fragment>
      )}
      <footer className="footer">Cohen Autos</footer>
    </React.Fragment>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
</script>
</body>
</html>
FILEEOF
echo "Actualizando admin/index.html..."
cat > admin/index.html << 'FILEEOF'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Panel — Cohen Autos</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Work+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
<script src="https://unpkg.com/@babel/standalone@7.24.7/babel.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<style>
  :root {
    --paper:#FAF6F0; --alt:#F1EAE0; --ink:#2B2420; --rust:#8C3B2E; --rustDark:#6C2C21;
    --brass:#B8874A; --line:#E4DCCB; --mute:#7C7266; --sidebar:#241D19;
  }
  * { box-sizing:border-box; }
  html, body { margin:0; height:100%; }
  body { background:var(--alt); color:var(--ink); font-family:'Work Sans',system-ui,sans-serif; }

  .shell { display:flex; min-height:100vh; }

  .sidebar { width:220px; background:var(--sidebar); color:#e9e2d8; flex-shrink:0; display:flex; flex-direction:column; padding:20px 0; }
  .sidebar-brand { font-family:'Fraunces',serif; font-weight:600; font-size:18px; padding:0 20px 20px; color:#fff; }
  .sidebar-brand span { color:var(--brass); }
  .nav-item { display:flex; align-items:center; gap:12px; padding:12px 20px; color:#c9beae; cursor:pointer; font-size:14px; border-left:3px solid transparent; }
  .nav-item svg { flex-shrink:0; opacity:0.8; }
  .nav-item:hover { background:rgba(255,255,255,0.04); color:#fff; }
  .nav-item.on { background:rgba(255,255,255,0.06); color:#fff; border-left-color:var(--brass); }
  .nav-item.on svg { opacity:1; }
  .sidebar-footer { margin-top:auto; padding:14px 20px 4px; }
  .sidebar-footer a { color:#c9beae; font-size:12.5px; text-decoration:none; }

  .topbar-mobile { display:none; align-items:center; gap:12px; padding:14px 16px; background:var(--sidebar); color:#fff; }
  .hamburger { background:none; border:none; color:#fff; cursor:pointer; padding:4px; }

  .main { flex:1; min-width:0; padding:32px 36px 60px; max-width:960px; }
  .view-title { font-family:'Fraunces',serif; font-weight:600; font-size:24px; color:var(--rustDark); margin:0 0 22px; }

  .settings, .form, .panel-card { background:#fff; border:1px solid var(--line); border-radius:10px; padding:24px; }
  .settings h2, .form h2 { margin:0 0 4px; font-size:16px; font-family:'Fraunces',serif; font-weight:600; color:var(--rustDark); }
  .form-section { margin-top:20px; }
  .form-section:first-of-type { margin-top:4px; }
  .form-section-title { font-size:11px; text-transform:uppercase; letter-spacing:0.7px; color:var(--mute); font-weight:600; margin:0 0 12px; padding-top:16px; border-top:1px solid var(--line); }
  .form-section:first-of-type .form-section-title { border-top:none; padding-top:0; }
  .settings-row { display:flex; gap:10px; }
  .settings-row input { flex:1; }
  .hint { font-size:12px; color:var(--mute); margin:6px 0 0; }
  .row { display:flex; gap:14px; flex-wrap:wrap; }
  .f { flex:1; min-width:140px; margin-bottom:14px; }
  .f.small { flex:0.6; min-width:100px; }
  .f label { display:block; font-size:12px; color:var(--mute); margin-bottom:6px; }
  .f input, .f select, .f textarea {
    width:100%; padding:10px 11px; border-radius:7px; border:1px solid var(--line);
    background:var(--alt); color:var(--ink); font-size:14.5px; font-family:'Work Sans',sans-serif;
  }
  .f input:focus, .f select:focus, .f textarea:focus { outline:2px solid var(--brass); outline-offset:1px; background:#fff; }
  .f textarea { min-height:160px; line-height:1.6; resize:vertical; }
  .thumbs-grid { display:flex; flex-wrap:wrap; gap:10px; }
  .thumb-item { width:84px; height:66px; border-radius:8px; background-size:cover; background-position:center; position:relative; border:1px solid var(--line); }
  .thumb-item .remove { position:absolute; top:-6px; right:-6px; width:20px; height:20px; border-radius:50%; background:var(--ink); color:#fff; border:none; cursor:pointer; font-size:13px; line-height:1; }
  .add-photo { width:84px; height:66px; border-radius:8px; border:1.5px dashed var(--line); display:flex; align-items:center; justify-content:center; font-size:12px; color:var(--mute); cursor:pointer; text-align:center; background:var(--alt); }
  .add-photo:hover { border-color:var(--brass); color:var(--rust); }
  .form-actions { display:flex; align-items:center; gap:12px; margin-top:20px; }
  .btn { background:var(--rust); color:#fff; border:none; padding:11px 22px; border-radius:7px; font-weight:600; cursor:pointer; font-size:14.5px; }
  .btn:hover { background:var(--rustDark); }
  .btn.ghost { background:transparent; border:1px solid var(--line); color:var(--ink); }
  .btn.ghost.danger { color:#B3261E; border-color:#e3c6c3; }
  .lista-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:14px; }
  .fila { display:flex; justify-content:space-between; align-items:center; padding:13px 16px; background:#fff; border:1px solid var(--line); border-radius:8px; margin-bottom:8px; }
  .fila-info { display:flex; flex-direction:column; gap:4px; }
  .fila-info strong { font-family:'Fraunces',serif; font-weight:600; font-size:15.5px; }
  .fila-info span { color:var(--mute); font-size:12.5px; }
  .fila-actions { display:flex; gap:8px; }
  .mute { color:var(--mute); }
  .empty-state { color:var(--mute); text-align:center; padding:40px 0; }
  .login { max-width:340px; margin:80px auto; background:#fff; border:1px solid var(--line); padding:28px; border-radius:10px; text-align:center; }
  .login h2 { font-family:'Fraunces',serif; }
  .login p { color:var(--mute); font-size:13px; margin-bottom:16px; }
  .login input { width:100%; padding:10px; border-radius:7px; border:1px solid var(--line); background:var(--alt); color:var(--ink); margin-bottom:12px; }
  .err { display:block; color:#B3261E; font-size:12px; margin-top:8px; }

  @media (max-width:860px) {
    .sidebar { position:fixed; top:0; left:0; bottom:0; z-index:20; transform:translateX(-100%); transition:transform .2s ease; }
    .sidebar.open { transform:translateX(0); }
    .topbar-mobile { display:flex; }
    .main { padding:24px 18px 60px; }
    .row { flex-direction:column; }
  }
</style>
</head>
<body>
<div id="root"></div>
<script type="text/babel" data-presets="react">
const { useState, useEffect, useRef } = React;

// ====== CONFIGURÁ ESTO con los datos de tu proyecto Supabase (los mismos que en /site) ======
const SUPABASE_URL = "https://qgjagerzvjptuzfimzbr.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnamFnZXJ6dmpwdHV6ZmltemJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0NjU1MDcsImV4cCI6MjA5OTA0MTUwN30.C0pGuw0e9UNWp3wEMKZFGjDzBQp28rysmFpVLBJelpg";
const SITE_URL = "https://cohen-autos.vercel.app";
const ADMIN_PASS = "auto2026";
// ==============================================================================================

const sb = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

function fmtMoney(n) { return "US$ " + Number(n).toLocaleString("es-AR"); }
function fmtKm(n) { return Number(n).toLocaleString("es-AR") + " km"; }
function selectAll(e) { e.target.select(); }

function compressImage(file, maxW = 900, quality = 0.72) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      const img = new Image();
      img.onload = () => {
        let w = img.width, h = img.height;
        if (w > maxW) { h = Math.round((h * maxW) / w); w = maxW; }
        const canvas = document.createElement("canvas");
        canvas.width = w; canvas.height = h;
        canvas.getContext("2d").drawImage(img, 0, 0, w, h);
        canvas.toBlob((blob) => resolve(blob), "image/jpeg", quality);
      };
      img.onerror = reject;
      img.src = e.target.result;
    };
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

async function uploadPhoto(blob) {
  const fileName = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}.jpg`;
  const { error } = await sb.storage.from("car-photos").upload(fileName, blob, { contentType: "image/jpeg" });
  if (error) { console.error(error); return null; }
  const { data } = sb.storage.from("car-photos").getPublicUrl(fileName);
  return data.publicUrl;
}

const CURRENT_YEAR = new Date().getFullYear();
const YEAR_OPTIONS = Array.from({ length: CURRENT_YEAR + 1 - 1990 + 1 }, (_, i) => CURRENT_YEAR + 1 - i);

const COMBUSTIBLES = [
  ["nafta", "Nafta"], ["diesel", "Diésel"], ["gnc", "GNC"], ["electrico", "Eléctrico"], ["hibrido", "Híbrido"],
];
const CARROCERIAS = [
  ["sedan", "Sedán"], ["hatchback", "Hatchback"], ["suv", "SUV"], ["pickup", "Pick-up"],
  ["coupe", "Coupé"], ["rural", "Rural / Familiar"], ["furgon", "Furgón / Utilitario"], ["cabriolet", "Cabriolet"],
];
const TRACCIONES = [["4x2", "4x2"], ["4x4", "4x4 / AWD"]];
const PUERTAS = [2, 3, 4, 5];

const empty = {
  marca: "", modelo: "", version: "", anio: CURRENT_YEAR, km: 0, precio: 0,
  condicion: "usado", transmision: "manual", combustible: "nafta", carroceria: "sedan",
  color: "", puertas: 4, traccion: "4x2", motor: "", fotos: [], descripcion: "",
};

function IconPublicar() {
  return <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M12 5v14M5 12h14" /></svg>;
}
function IconLista() {
  return <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M4 6h16M4 12h16M4 18h10" /></svg>;
}
function IconConfig() {
  return (
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.7 1.7 0 0 0 .34 1.87l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.7 1.7 0 0 0-1.87-.34 1.7 1.7 0 0 0-1.04 1.56V21a2 2 0 0 1-4 0v-.09A1.7 1.7 0 0 0 9 19.35a1.7 1.7 0 0 0-1.87.34l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.7 1.7 0 0 0 4.65 15a1.7 1.7 0 0 0-1.56-1.04H3a2 2 0 0 1 0-4h.09A1.7 1.7 0 0 0 4.65 9a1.7 1.7 0 0 0-.34-1.87l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.7 1.7 0 0 0 9 4.65a1.7 1.7 0 0 0 1.04-1.56V3a2 2 0 0 1 4 0v.09a1.7 1.7 0 0 0 1.04 1.56 1.7 1.7 0 0 0 1.87-.34l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.7 1.7 0 0 0 19.35 9c.13.51.5.93 1.56 1.04H21a2 2 0 0 1 0 4h-.09a1.7 1.7 0 0 0-1.51 1z" />
    </svg>
  );
}
function IconHamburger() {
  return <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M3 6h18M3 12h18M3 18h18" /></svg>;
}

function PhotoUploader({ fotos, onChange }) {
  const [busy, setBusy] = useState(false);
  const inputRef = useRef(null);
  async function handleFiles(e) {
    const files = Array.from(e.target.files || []);
    if (!files.length) return;
    setBusy(true);
    const nuevas = [];
    for (const f of files) {
      try {
        const blob = await compressImage(f);
        const url = await uploadPhoto(blob);
        if (url) nuevas.push(url);
      } catch (err) { console.error(err); }
    }
    onChange([...fotos, ...nuevas]);
    setBusy(false);
    if (inputRef.current) inputRef.current.value = "";
  }
  return (
    <div className="thumbs-grid">
      {fotos.map((f, i) => (
        <div className="thumb-item" key={i} style={{ backgroundImage: `url(${f})` }}>
          <button type="button" className="remove" onClick={() => onChange(fotos.filter((_, idx) => idx !== i))}>×</button>
        </div>
      ))}
      <label className="add-photo">
        {busy ? "Subiendo..." : "+ Foto"}
        <input ref={inputRef} type="file" accept="image/*" multiple onChange={handleFiles} hidden />
      </label>
    </div>
  );
}

function PublicarView({ form, setForm, editId, onSubmit, onCancel }) {
  function set(field, val) { setForm(f => ({ ...f, [field]: val })); }
  return (
    <form className="form" onSubmit={onSubmit}>
      <h2>{editId ? "Editar auto" : "Publicar auto"}</h2>

      <div className="form-section">
        <p className="form-section-title">Datos principales</p>
        <div className="row">
          <div className="f"><label>Marca</label><input value={form.marca} onChange={e => set("marca", e.target.value)} required /></div>
          <div className="f"><label>Modelo</label><input value={form.modelo} onChange={e => set("modelo", e.target.value)} required /></div>
          <div className="f"><label>Versión</label><input value={form.version} onChange={e => set("version", e.target.value)} placeholder="Ej: Highline, Trend, GLS" /></div>
        </div>
        <div className="row">
          <div className="f small">
            <label>Año</label>
            <select value={form.anio} onChange={e => set("anio", Number(e.target.value))}>
              {YEAR_OPTIONS.map(y => <option key={y} value={y}>{y}</option>)}
            </select>
          </div>
          <div className="f"><label>Kilómetros</label><input type="number" value={form.km} onFocus={selectAll} onChange={e => set("km", Number(e.target.value))} /></div>
          <div className="f"><label>Precio (USD)</label><input type="number" value={form.precio} onFocus={selectAll} onChange={e => set("precio", Number(e.target.value))} /></div>
        </div>
        <div className="row">
          <div className="f"><label>Condición</label>
            <select value={form.condicion} onChange={e => set("condicion", e.target.value)}>
              <option value="usado">Usado</option><option value="nuevo">0km</option>
            </select>
          </div>
          <div className="f"><label>Color</label><input value={form.color} onChange={e => set("color", e.target.value)} /></div>
        </div>
      </div>

      <div className="form-section">
        <p className="form-section-title">Especificaciones técnicas</p>
        <div className="row">
          <div className="f"><label>Transmisión</label>
            <select value={form.transmision} onChange={e => set("transmision", e.target.value)}>
              <option value="manual">Manual</option><option value="automatico">Automático</option>
            </select>
          </div>
          <div className="f"><label>Combustible</label>
            <select value={form.combustible} onChange={e => set("combustible", e.target.value)}>
              {COMBUSTIBLES.map(([v, l]) => <option key={v} value={v}>{l}</option>)}
            </select>
          </div>
          <div className="f"><label>Carrocería</label>
            <select value={form.carroceria} onChange={e => set("carroceria", e.target.value)}>
              {CARROCERIAS.map(([v, l]) => <option key={v} value={v}>{l}</option>)}
            </select>
          </div>
        </div>
        <div className="row">
          <div className="f small"><label>Puertas</label>
            <select value={form.puertas} onChange={e => set("puertas", Number(e.target.value))}>
              {PUERTAS.map(p => <option key={p} value={p}>{p}</option>)}
            </select>
          </div>
          <div className="f"><label>Tracción</label>
            <select value={form.traccion} onChange={e => set("traccion", e.target.value)}>
              {TRACCIONES.map(([v, l]) => <option key={v} value={v}>{l}</option>)}
            </select>
          </div>
          <div className="f"><label>Motor / Cilindrada</label><input value={form.motor} onChange={e => set("motor", e.target.value)} placeholder="Ej: 1.6, 2.0 Turbo" /></div>
        </div>
      </div>

      <div className="form-section">
        <p className="form-section-title">Fotos</p>
        <PhotoUploader fotos={form.fotos} onChange={(f) => set("fotos", f)} />
      </div>

      <div className="form-section">
        <p className="form-section-title">Descripción</p>
        <textarea value={form.descripcion} onChange={e => set("descripcion", e.target.value)} rows={8} placeholder="Contá los detalles que quieras destacar del auto: estado general, service, detalles de la unidad, equipamiento, etc." />
      </div>

      <div className="form-actions">
        <button className="btn" type="submit">{editId ? "Guardar cambios" : "Publicar"}</button>
        {editId && <button type="button" className="btn ghost" onClick={onCancel}>Cancelar edición</button>}
      </div>
    </form>
  );
}

function PublicadosView({ cars, onEdit, onDelete }) {
  return (
    <div className="panel-card">
      <div className="lista-head"><strong>{cars.length} {cars.length === 1 ? "auto publicado" : "autos publicados"}</strong></div>
      {cars.map(c => (
        <div className="fila" key={c.id}>
          <div className="fila-info">
            <strong>{c.marca} {c.modelo} {c.version}</strong>
            <span>{c.anio} · {fmtKm(c.km)} · {fmtMoney(c.precio)} · {c.condicion === "nuevo" ? "0km" : "usado"}</span>
          </div>
          <div className="fila-actions">
            <button className="btn ghost" onClick={() => onEdit(c)}>Editar</button>
            <button className="btn ghost danger" onClick={() => onDelete(c.id)}>Borrar</button>
          </div>
        </div>
      ))}
      {cars.length === 0 && <p className="empty-state">Todavía no publicaste ningún auto. Andá a "Publicar" para cargar el primero.</p>}
    </div>
  );
}

function ConfigView({ phoneInput, setPhoneInput, onSave, siteUrl }) {
  return (
    <div className="settings">
      <h2>Configuración</h2>
      <p className="hint">Número de WhatsApp con código de país, sin + ni espacios. Ej: 5491122334455</p>
      <div className="settings-row">
        <input value={phoneInput} onChange={e => setPhoneInput(e.target.value)} placeholder="5491122334455" />
        <button className="btn" type="button" onClick={onSave}>Guardar</button>
      </div>
      <p className="hint" style={{ marginTop: 18 }}>Tu página pública: <a href={siteUrl} target="_blank" rel="noreferrer">{siteUrl}</a></p>
    </div>
  );
}

function App() {
  const [auth, setAuth] = useState(false);
  const [pass, setPass] = useState("");
  const [cars, setCars] = useState([]);
  const [whatsapp, setWhatsapp] = useState("");
  const [phoneInput, setPhoneInput] = useState("");
  const [form, setForm] = useState(empty);
  const [editId, setEditId] = useState(null);
  const [loading, setLoading] = useState(true);
  const [view, setView] = useState("publicar");
  const [sidebarOpen, setSidebarOpen] = useState(false);

  async function loadAll() {
    const { data: carsData } = await sb.from("cars").select("*").order("created_at", { ascending: false });
    const { data: settingsData } = await sb.from("settings").select("whatsapp").eq("id", 1).single();
    setCars(carsData || []);
    setWhatsapp((settingsData && settingsData.whatsapp) || "");
    setPhoneInput((settingsData && settingsData.whatsapp) || "");
    setLoading(false);
  }
  useEffect(() => { if (auth) loadAll(); }, [auth]);

  if (!auth) {
    return (
      <div className="login">
        <h2>Acceso al panel</h2>
        <p>Ingresá la clave para publicar autos.</p>
        <input type="password" placeholder="Clave" value={pass} onChange={e => setPass(e.target.value)}
          onKeyDown={e => e.key === "Enter" && pass === ADMIN_PASS && setAuth(true)} />
        <button className="btn" onClick={() => pass === ADMIN_PASS && setAuth(true)}>Entrar</button>
        {pass && pass !== ADMIN_PASS && <span className="err">Clave incorrecta</span>}
      </div>
    );
  }
  if (loading) return <p style={{ padding: 28, color: "var(--mute)" }}>Cargando...</p>;

  function reset() { setForm(empty); setEditId(null); }
  function edit(car) { setForm({ ...empty, ...car }); setEditId(car.id); setView("publicar"); setSidebarOpen(false); }
  function goTo(v) { setView(v); setSidebarOpen(false); if (v === "publicar" && !editId) reset(); }

  async function submit(e) {
    e.preventDefault();
    if (!form.marca || !form.modelo) return;
    const payload = { ...form };
    delete payload.id; delete payload.created_at;
    if (editId) await sb.from("cars").update(payload).eq("id", editId);
    else await sb.from("cars").insert(payload);
    reset();
    await loadAll();
    setView("publicados");
  }
  async function handleDelete(id) { await sb.from("cars").delete().eq("id", id); loadAll(); }
  async function saveSettings() { await sb.from("settings").update({ whatsapp: phoneInput.trim() }).eq("id", 1); setWhatsapp(phoneInput.trim()); }

  const titles = { publicar: editId ? "Editar auto" : "Publicar auto", publicados: "Publicados", config: "Configuración" };

  return (
    <div className="shell">
      <div className="topbar-mobile">
        <button className="hamburger" onClick={() => setSidebarOpen(s => !s)}><IconHamburger /></button>
        <div className="sidebar-brand" style={{ padding: 0 }}>Cohen <span>Autos</span></div>
      </div>

      <aside className={"sidebar" + (sidebarOpen ? " open" : "")}>
        <div className="sidebar-brand">Cohen <span>Autos</span></div>
        <div className={"nav-item" + (view === "publicar" ? " on" : "")} onClick={() => goTo("publicar")}><IconPublicar /> Publicar</div>
        <div className={"nav-item" + (view === "publicados" ? " on" : "")} onClick={() => goTo("publicados")}><IconLista /> Publicados</div>
        <div className={"nav-item" + (view === "config" ? " on" : "")} onClick={() => goTo("config")}><IconConfig /> Configuración</div>
        <div className="sidebar-footer"><a href={SITE_URL} target="_blank" rel="noreferrer">Ver la página →</a></div>
      </aside>

      <main className="main">
        <h1 className="view-title">{titles[view]}</h1>
        {view === "publicar" && <PublicarView form={form} setForm={setForm} editId={editId} onSubmit={submit} onCancel={reset} />}
        {view === "publicados" && <PublicadosView cars={cars} onEdit={edit} onDelete={handleDelete} />}
        {view === "config" && <ConfigView phoneInput={phoneInput} setPhoneInput={setPhoneInput} onSave={saveSettings} siteUrl={SITE_URL} />}
      </main>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
</script>
</body>
</html>
FILEEOF
echo "Subiendo a GitHub..."
git add -A
git commit -m "Vista de detalle con zoom de fotos, sin filtros combustible/carroceria, descripcion mas grande" || echo "Nada nuevo para commitear"
git push
echo ""
echo "LISTO."
