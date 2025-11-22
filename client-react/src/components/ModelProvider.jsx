import { useModel } from "../model/model.js";
import { createContext, useContext } from "react";

const ModelContext = createContext(undefined);

export function ModelProvider(props) {
  const model = useModel();

  return (
    <ModelContext.Provider value={model}>
      {props.children}
    </ModelContext.Provider>
  );
}

export function useModelContext() {
  return useContext(ModelContext);
}
