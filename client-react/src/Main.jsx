import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./Main.css";
import HomePage from "./pages/HomePage.jsx";
import { ModelProvider, useModelContext } from "./components/index.js";
import { LoadingPage } from "./pages/index.js";

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <ModelProvider>
      <Main />
    </ModelProvider>
  </StrictMode>,
);

function Main(props) {
  const model = useModelContext();

  return <>
    {!model.ready && <LoadingPage />}
    {model.ready && <HomePage />}</>;
}
