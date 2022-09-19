import { RecoilRoot } from "recoil";
import NavBar from "./components/NavBar";
import "react-calendar/dist/Calendar.css";
import "./styles.scss";
import { ToastContainer } from "react-toastify";
import 'react-toastify/dist/ReactToastify.css';
import {
  QueryClient,
  QueryClientProvider,
  useQuery,
} from "@tanstack/react-query";
import IndexPage from "./page/index.page";

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <RecoilRoot>
        <ToastContainer />
        <div className="container px-0 mx-auto bg-white main-app-container">
          <NavBar />
          <IndexPage />
        </div>
      </RecoilRoot>
    </QueryClientProvider>
  );
}

export default App;
