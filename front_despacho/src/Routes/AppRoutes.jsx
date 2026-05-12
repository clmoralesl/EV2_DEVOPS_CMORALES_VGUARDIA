import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { CrudAdmin } from "../componentes/CrudAdmin.jsx";
import { TableCompras } from "../componentes/CrudAdmin/TableCompras.jsx";
import { TableDespachos } from "../componentes/CrudAdmin/TableDespachos.jsx";
import Navbar from "../componentes/Layouts/Navbar";
import Footer from "../componentes/Layouts/Footer";

const AppRoutes = () => {
  return (
    <Router>
      <div className="grid grid-cols-[auto_1fr] min-h-screen bg-gray-50">
        <Navbar />
        <div className="overflow-y-auto p-6 flex flex-col justify-between">
          <Routes>
            <Route path="/" element={<CrudAdmin />} />
            <Route path="/compras" element={<TableCompras />} />
            <Route path="/despachos" element={<TableDespachos />} />
          </Routes>
          <Footer />
        </div>
      </div>
    </Router>
  );
};

export default AppRoutes;
