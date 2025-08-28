import React, { useState } from "react";
import api from "../api";
import {
  Alert,
  AppBar,
  Box,
  Button,
  Card,
  CardContent,
  CircularProgress,
  Container,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Toolbar,
  Typography,
} from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";

export default function Doctors() {
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchDoctors = async () => {
    setLoading(true);
    setError(null);
    try {
        const { data } = await api.get("/doctor");
      setDoctors(data);
    } catch (e) {
      setError("No se pudo obtener la lista de doctores.");
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box sx={{ minHeight: "100vh", bgcolor: "#f7f7fb" }}>
      <AppBar position="static" elevation={0}>
        <Toolbar>
          <Typography variant="h6">Clínica · Doctores</Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="md" sx={{ py: 4 }}>
        <Card elevation={2} sx={{ borderRadius: 3 }}>
          <CardContent>
            <Box
              sx={{
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
                mb: 2,
              }}
            >
              <Typography variant="h5">Listado de Doctores</Typography>

              <Button
                variant="contained"
                startIcon={<SearchIcon />}
                onClick={fetchDoctors}
                disabled={loading}
              >
                {loading ? "Consultando..." : "Consultar"}
              </Button>
            </Box>

            {error && (
              <Alert severity="error" sx={{ mb: 2 }}>
                {error}
              </Alert>
            )}

            <TableContainer
              component={Paper}
              elevation={0}
              sx={{ borderRadius: 2, border: "1px solid rgba(0,0,0,0.06)" }}
            >
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell><b>ID</b></TableCell>
                    <TableCell><b>Nombre</b></TableCell>
                    <TableCell><b>Especialidad</b></TableCell>
                  </TableRow>
                </TableHead>

                <TableBody>
                  {loading ? (
                    <TableRow>
                      <TableCell colSpan={3} align="center">
                        <CircularProgress size={24} />
                      </TableCell>
                    </TableRow>
                  ) : doctors.length > 0 ? (
                    doctors.map((d) => (
                      <TableRow key={d.id}>
                        <TableCell>{d.id}</TableCell>
                        <TableCell>{d.name}</TableCell>
                        <TableCell>{d.specialty}</TableCell>
                      </TableRow>
                    ))
                  ) : (
                    <TableRow>
                      <TableCell colSpan={3} align="center">
                        No hay datos aún. Presiona <b>“Consultar”</b>.
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          </CardContent>
        </Card>
      </Container>
    </Box>
  );
}
