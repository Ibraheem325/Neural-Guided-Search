(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	satellite4 - satellite
	instrument6 - instrument
	satellite5 - satellite
	instrument7 - instrument
	satellite6 - satellite
	instrument8 - instrument
	satellite7 - satellite
	instrument9 - instrument
	instrument10 - instrument
	spectrograph0 - mode
	GroundStation2 - direction
	Star4 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	GroundStation0 - direction
	Star9 - direction
	Star15 - direction
	GroundStation10 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	Star11 - direction
	GroundStation3 - direction
	Star16 - direction
	GroundStation5 - direction
	Star6 - direction
	Planet17 - direction
	Star18 - direction
	Planet19 - direction
	Phenomenon20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Phenomenon23 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star15)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star15)
	(calibration_target instrument1 GroundStation0)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 Star15)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star16)
	(calibration_target instrument3 GroundStation5)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 Star16)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation1)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation1)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 Star15)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation0)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 GroundStation1)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star9)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 Star16)
	(calibration_target instrument7 GroundStation5)
	(on_board instrument7 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Phenomenon23)
	(supports instrument8 spectrograph0)
	(calibration_target instrument8 Star11)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation2)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 Star16)
	(calibration_target instrument9 GroundStation3)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 Star6)
	(calibration_target instrument10 GroundStation5)
	(on_board instrument9 satellite7)
	(on_board instrument10 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Star18)
)
(:goal (and
	(pointing satellite0 GroundStation7)
	(pointing satellite7 Phenomenon22)
	(have_image Planet17 spectrograph0)
	(have_image Star18 spectrograph0)
	(have_image Planet19 spectrograph0)
	(have_image Phenomenon20 spectrograph0)
	(have_image Star21 spectrograph0)
	(have_image Phenomenon22 spectrograph0)
	(have_image Phenomenon23 spectrograph0)
))

)
